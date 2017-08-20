package Spreadsheet::ParseXLSX;
BEGIN {
  $Spreadsheet::ParseXLSX::AUTHORITY = 'cpan:DOY';
}
$Spreadsheet::ParseXLSX::VERSION = '0.16';
use strict;
use warnings;
# ABSTRACT: parse XLSX files

use Archive::Zip;
use Graphics::ColorUtils 'rgb2hls', 'hls2rgb';
use Scalar::Util 'openhandle';
use Spreadsheet::ParseExcel 0.61;
use XML::Twig;



sub new {
    bless {}, shift;
}


sub parse {
    my $self = shift;
    my ($file, $formatter) = @_;

    my $zip = Archive::Zip->new;
    my $workbook = Spreadsheet::ParseExcel::Workbook->new;
    if (openhandle($file)) {
        bless $file, 'IO::File' if ref($file) eq 'GLOB'; # sigh
        $zip->readFromFileHandle($file) == Archive::Zip::AZ_OK
            or die "Can't open filehandle as a zip file";
        $workbook->{File} = undef;
    }
    elsif (!ref($file)) {
        $zip->read($file) == Archive::Zip::AZ_OK
            or die "Can't open file '$file' as a zip file";
        $workbook->{File} = $file;
    }
    else {
        die "Argument to 'new' must be a filename or open filehandle";
    }

    return $self->_parse_workbook($zip, $workbook, $formatter);
}

sub _parse_workbook {
    my $self = shift;
    my ($zip, $workbook, $formatter) = @_;

    my $files = $self->_extract_files($zip);

    my ($version)    = $files->{workbook}->find_nodes('//fileVersion');
    my ($properties) = $files->{workbook}->find_nodes('//workbookPr');

    if ($version) {
        $workbook->{Version} = $version->att('appName')
                             . ($version->att('lowestEdited')
                                 ? ('-' . $version->att('lowestEdited'))
                                 : (""));
    }

    $workbook->{Flag1904} = $properties && $properties->att('date1904') ? 1 : 0;

    $workbook->{FmtClass} = $formatter || Spreadsheet::ParseExcel::FmtDefault->new;

    my $themes = $self->_parse_themes((values %{ $files->{themes} })[0]); # XXX

    $workbook->{Color} = $themes->{Color};

    my $styles = $self->_parse_styles($workbook, $files->{styles});

    $workbook->{Format}    = $styles->{Format};
    $workbook->{FormatStr} = $styles->{FormatStr};
    $workbook->{Font}      = $styles->{Font};

    $workbook->{PkgStr} = $self->_parse_shared_strings($files->{strings})
        if $files->{strings};

    # $workbook->{StandardWidth} = ...;

    # $workbook->{Author} = ...;

    # $workbook->{PrintArea} = ...;
    # $workbook->{PrintTitle} = ...;

    my @sheets = map {
        my $idx = $_->att('r:id');
        my $sheet = Spreadsheet::ParseExcel::Worksheet->new(
            Name     => $_->att('name'),
            _Book    => $workbook,
            _SheetNo => $idx,
        );
        $self->_parse_sheet($sheet, $files->{sheets}{$idx});
        $sheet
    } $files->{workbook}->find_nodes('//sheets/sheet');

    $workbook->{Worksheet}  = \@sheets;
    $workbook->{SheetCount} = scalar(@sheets);

    my ($node) = $files->{workbook}->find_nodes('//workbookView');
    my $selected = $node->att('activeTab');
    $workbook->{SelectedSheet} = defined($selected) ? 0+$selected : 0;

    return $workbook;
}

sub _parse_sheet {
    my $self = shift;
    my ($sheet, $sheet_file) = @_;

    $sheet->{MinRow} = 0;
    $sheet->{MinCol} = 0;
    $sheet->{MaxRow} = -1;
    $sheet->{MaxCol} = -1;
    $sheet->{Selection} = [ 0, 0 ];

    my @merged_cells;

    my @column_formats;
    my @column_widths;
    my @row_heights;

    my $default_row_height   = 15;
    my $default_column_width = 10;

    my $sheet_xml = XML::Twig->new(
        twig_roots => {
            #XXX need a fallback here, the dimension tag is optional
            'dimension' => sub {
                my ($twig, $dimension) = @_;

                my ($rmin, $cmin, $rmax, $cmax) = $self->_dimensions(
                    $dimension->att('ref')
                );

                $sheet->{MinRow} = $rmin;
                $sheet->{MinCol} = $cmin;
                $sheet->{MaxRow} = $rmax;
                $sheet->{MaxCol} = $cmax;

                $twig->purge;
            },

            'mergeCells/mergeCell' => sub {
                my ( $twig, $merge_area ) = @_;

                if (my $ref = $merge_area->att('ref')) {
                    my ($topleft, $bottomright) = $ref =~ /([^:]+):([^:]+)/;

                    my ($toprow, $leftcol)     = $self->_cell_to_row_col($topleft);
                    my ($bottomrow, $rightcol) = $self->_cell_to_row_col($bottomright);

                    push @{ $sheet->{MergedArea} }, [
                        $toprow, $leftcol,
                        $bottomrow, $rightcol,
                    ];
                    for my $row ($toprow .. $bottomrow) {
                        for my $col ($leftcol .. $rightcol) {
                            push(@merged_cells, [$row, $col]);
                        }
                    }
                }

                $twig->purge;
            },

            'sheetFormatPr' => sub {
                my ( $twig, $format ) = @_;

                $default_row_height   //= $format->att('defaultRowHeight');
                $default_column_width //= $format->att('baseColWidth');

                $twig->purge;
            },

            'col' => sub {
                my ( $twig, $col ) = @_;

                for my $colnum ($col->att('min')..$col->att('max')) {
                    $column_widths[$colnum - 1] = $col->att('width');
                    $column_formats[$colnum - 1] = $col->att('style');
                }

                $twig->purge;
            },

            'row' => sub {
                my ( $twig, $row ) = @_;

                $row_heights[ $row->att('r') - 1 ] = $row->att('ht');

                $twig->purge;
            },

            'selection' => sub {
                my ( $twig, $selection ) = @_;

                if (my $cell = $selection->att('activeCell')) {
                    $sheet->{Selection} = [ $self->_cell_to_row_col($cell) ];
                }
                elsif (my $range = $selection->att('sqref')) {
                    my ($topleft, $bottomright) = $range =~ /([^:]+):([^:]+)/;
                    $sheet->{Selection} = [
                        $self->_cell_to_row_col($topleft),
                        $self->_cell_to_row_col($bottomright),
                    ];
                }

                $twig->purge;
            },

            'sheetPr/tabColor' => sub {
                my ( $twig, $tab_color ) = @_;

                $sheet->{TabColor} = $self->_color($sheet->{_Book}{Color}, $tab_color);

                $twig->purge;
            },

        }
    );

    $sheet_xml->parse( $sheet_file );

    # 2nd pass: cell/row building is dependent on having parsed the merge definitions
    # beforehand.

    $sheet_xml = XML::Twig->new(
        twig_roots => {
            'sheetData/row' => sub {
                my ( $twig, $row_elt ) = @_;

                for my $cell ( $row_elt->children('c') ){
                    my ($row, $col) = $self->_cell_to_row_col($cell->att('r'));
                    my $type = $cell->att('t') || 'n';
                    my $val_xml = $type eq 'inlineStr'
                        ? $cell->first_child('is')->first_child('t')
                        : $cell->first_child('v');
                    my $val = $val_xml ? $val_xml->text : undef;

                    my $long_type;
                    if (!defined($val)) {
                        $long_type = 'Text';
                        $val = '';
                    }
                    elsif ($type eq 's') {
                        $long_type = 'Text';
                        $val = $sheet->{_Book}{PkgStr}[$val];
                    }
                    elsif ($type eq 'n') {
                        $long_type = 'Numeric';
                        $val = defined($val) ? 0+$val : undef;
                    }
                    elsif ($type eq 'd') {
                        $long_type = 'Date';
                    }
                    elsif ($type eq 'b') {
                        $long_type = 'Text';
                        $val = $val ? "TRUE" : "FALSE";
                    }
                    elsif ($type eq 'e') {
                        $long_type = 'Text';
                    }
                    elsif ($type eq 'str' || $type eq 'inlineStr') {
                        $long_type = 'Text';
                    }
                    else {
                        die "unimplemented type $type"; # XXX
                    }

                    my $format_idx = $cell->att('s') || 0;
                    my $format = $sheet->{_Book}{Format}[$format_idx];
                    $format->{Merged} = !!grep {
                        $row == $_->[0] && $col == $_->[1]
                    } @merged_cells;

                    # see the list of built-in formats below in _parse_styles
                    # XXX probably should figure this out from the actual format string,
                    # but that's not entirely trivial
                    if (grep { $format->{FmtIdx} == $_ } 14..22, 45..47) {
                        $long_type = 'Date';
                    }

                    my $cell = Spreadsheet::ParseExcel::Cell->new(
                        Val      => $val,
                        Type     => $long_type,
                        Merged   => $format->{Merged},
                        Format   => $format,
                        FormatNo => $format_idx,
                        ($cell->first_child('f')
                            ? (Formula => $cell->first_child('f')->text)
                            : ()),
                    );
                    $cell->{_Value} = $sheet->{_Book}{FmtClass}->ValFmt(
                        $cell, $sheet->{_Book}
                    );
                    $sheet->{Cells}[$row][$col] = $cell;
                }

                $twig->purge;
            },

        }
    );

    $sheet_xml->parse( $sheet_file );

    if ( ! $sheet->{Cells} ){
        $sheet->{MaxRow} = $sheet->{MaxCol} = -1;
    }

    $sheet->{DefRowHeight} = 0+$default_row_height;
    $sheet->{DefColWidth} = 0+$default_column_width;
    $sheet->{RowHeight} = [
        map { defined $_ ? 0+$_ : 0+$default_row_height } @row_heights
    ];
    $sheet->{ColWidth} = [
        map { defined $_ ? 0+$_ : 0+$default_column_width } @column_widths
    ];
    $sheet->{ColFmtNo} = \@column_formats;

}

sub _parse_shared_strings {
    my $self = shift;
    my ($strings) = @_;

    my $PkgStr = [];

    if ($strings) {
        my $xml = XML::Twig->new(
            twig_handlers => {
                'si' => sub {
                    my ( $twig, $si ) = @_;

                    # XXX this discards information about formatting within cells
                    # not sure how to represent that
                    push @$PkgStr,
                      join( '', map { $_->text } $si->find_nodes('.//t') );
                    $twig->purge;
                },
            }
        );
        $xml->parse( $strings );
    }
    return $PkgStr;
}

sub _parse_themes {
    my $self = shift;
    my ($themes) = @_;

    return {} unless $themes;

    my @color = map {
        $_->name eq 'a:sysClr' ? $_->att('lastClr') : $_->att('val')
    } $themes->find_nodes('//a:clrScheme/*/*');

    # this shouldn't be necessary, but the documentation is wrong here
    # see http://stackoverflow.com/questions/2760976/theme-confusion-in-spreadsheetml
    ($color[0], $color[1]) = ($color[1], $color[0]);
    ($color[2], $color[3]) = ($color[3], $color[2]);

    return {
        Color => \@color,
    }
}

sub _parse_styles {
    my $self = shift;
    my ($workbook, $styles) = @_;

    my %halign = (
        center           => 2,
        centerContinuous => 6,
        distributed      => 7,
        fill             => 4,
        general          => 0,
        justify          => 5,
        left             => 1,
        right            => 3,
    );

    my %valign = (
        bottom      => 2,
        center      => 1,
        distributed => 4,
        justify     => 3,
        top         => 0,
    );

    my %border = (
        dashDot          => 9,
        dashDotDot       => 11,
        dashed           => 3,
        dotted           => 4,
        double           => 6,
        hair             => 7,
        medium           => 2,
        mediumDashDot    => 10,
        mediumDashDotDot => 12,
        mediumDashed     => 8,
        none             => 0,
        slantDashDot     => 13,
        thick            => 5,
        thin             => 1,
    );

    my %fill = (
        darkDown        => 7,
        darkGray        => 3,
        darkGrid        => 9,
        darkHorizontal  => 5,
        darkTrellis     => 10,
        darkUp          => 8,
        darkVertical    => 6,
        gray0625        => 18,
        gray125         => 17,
        lightDown       => 13,
        lightGray       => 4,
        lightGrid       => 15,
        lightHorizontal => 11,
        lightTrellis    => 16,
        lightUp         => 14,
        lightVertical   => 12,
        mediumGray      => 2,
        none            => 0,
        solid           => 1,
    );

    my @fills = map {
        [
            $fill{$_->att('patternType')},
            $self->_color($workbook->{Color}, $_->first_child('fgColor'), 1),
            $self->_color($workbook->{Color}, $_->first_child('bgColor'), 1),
        ]
    } $styles->find_nodes('//fills/fill/patternFill');

    my @borders = map {
        my $border = $_;
        # XXX specs say "begin" and "end" rather than "left" and "right",
        # but... that's not what seems to be in the file itself (sigh)
        {
            colors => [
                map {
                    $self->_color(
                        $workbook->{Color},
                        $border->first_child($_)->first_child('color')
                    )
                } qw(left right top bottom)
            ],
            styles => [
                map {
                    $border{$border->first_child($_)->att('style') || 'none'}
                } qw(left right top bottom)
            ],
            diagonal => [
                0, # XXX ->att('diagonalDown') and ->att('diagonalUp')
                0, # XXX ->att('style')
                $self->_color(
                    $workbook->{Color},
                    $border->first_child('diagonal')->first_child('color')
                ),
            ],
        }
    } $styles->find_nodes('//borders/border');

    # these defaults are from
    # http://social.msdn.microsoft.com/Forums/en-US/oxmlsdk/thread/e27aaf16-b900-4654-8210-83c5774a179c
    my %format_str = (
        0  => 'GENERAL',
        1  => '0',
        2  => '0.00',
        3  => '#,##0',
        4  => '#,##0.00',
        5  => '$#,##0_);($#,##0)',
        6  => '$#,##0_);[Red]($#,##0)',
        7  => '$#,##0.00_);($#,##0.00)',
        8  => '$#,##0.00_);[Red]($#,##0.00)',
        9  => '0%',
        10 => '0.00%',
        11 => '0.00E+00',
        12 => '# ?/?',
        13 => '# ??/??',
        14 => 'm/d/yyyy',
        15 => 'd-mmm-yy',
        16 => 'd-mmm',
        17 => 'mmm-yy',
        18 => 'h:mm AM/PM',
        19 => 'h:mm:ss AM/PM',
        20 => 'h:mm',
        21 => 'h:mm:ss',
        22 => 'm/d/yyyy h:mm',
        37 => '#,##0_);(#,##0)',
        38 => '#,##0_);[Red](#,##0)',
        39 => '#,##0.00_);(#,##0.00)',
        40 => '#,##0.00_);[Red](#,##0.00)',
        45 => 'mm:ss',
        46 => '[h]:mm:ss',
        47 => 'mm:ss.0',
        48 => '##0.0E+0',
        49 => '@',
        (map {
            $_->att('numFmtId') => $_->att('formatCode')
        } $styles->find_nodes('//numFmts/numFmt')),
    );

    my @font = map {
        my $vert = $_->first_child('vertAlign');
        my $under = $_->first_child('u');
        Spreadsheet::ParseExcel::Font->new(
            Height         => 0+$_->first_child('sz')->att('val'),
            # Attr           => $iAttr,
            # XXX not sure if there's a better way to keep the indexing stuff
            # intact rather than just going straight to #xxxxxx
            # XXX also not sure what it means for the color tag to be missing,
            # just assuming black for now
            Color          => ($_->first_child('color')
                ? $self->_color(
                    $workbook->{Color},
                    $_->first_child('color')
                )
                : '#000000'
            ),
            Super          => ($vert
                ? ($vert->att('val') eq 'superscript' ? 1
                 : $vert->att('val') eq 'subscript'   ? 2
                 :                                      0)
                : 0
            ),
            # XXX not sure what the single accounting and double accounting
            # underline styles map to in xlsx. also need to map the new
            # underline styles
            UnderlineStyle => ($under
                # XXX sometimes style xml files can contain just <u/> with no
                # val attribute. i think this means single underline, but not
                # sure
                ? (!$under->att('val')            ? 1
                 : $under->att('val') eq 'single' ? 1
                 : $under->att('val') eq 'double' ? 2
                 :                                  0)
                : 0
            ),
            Name           => $_->first_child('name')->att('val'),

            Bold      => $_->has_child('b') ? 1 : 0,
            Italic    => $_->has_child('i') ? 1 : 0,
            Underline => $_->has_child('u') ? 1 : 0,
            Strikeout => $_->has_child('strike') ? 1 : 0,
        )
    } $styles->find_nodes('//fonts/font');

    my @format = map {
        my $alignment  = $_->first_child('alignment');
        my $protection = $_->first_child('protection');
        Spreadsheet::ParseExcel::Format->new(
            IgnoreFont         => !$_->att('applyFont'),
            IgnoreFill         => !$_->att('applyFill'),
            IgnoreBorder       => !$_->att('applyBorder'),
            IgnoreAlignment    => !$_->att('applyAlignment'),
            IgnoreNumberFormat => !$_->att('applyNumberFormat'),
            IgnoreProtection   => !$_->att('applyProtection'),

            FontNo => 0+$_->att('fontId'),
            Font   => $font[$_->att('fontId')],
            FmtIdx => 0+$_->att('numFmtId'),

            Lock => $protection && defined $protection->att('locked')
                ? $protection->att('locked')
                : 1,
            Hidden => $protection
                ? $protection->att('hidden')
                : 0,
            # Style    => $iStyle,
            # Key123   => $i123,
            AlignH => $alignment
                ? $halign{$alignment->att('horizontal') || 'general'}
                : 0,
            Wrap => $alignment
                ? $alignment->att('wrapText')
                : 0,
            AlignV => $alignment
                ? $valign{$alignment->att('vertical') || 'bottom'}
                : 2,
            # JustLast => $iJustL,
            # Rotate   => $iRotate,

            # Indent  => $iInd,
            # Shrink  => $iShrink,
            # Merge   => $iMerge,
            # ReadDir => $iReadDir,

            BdrStyle => $borders[$_->att('borderId')]{styles},
            BdrColor => $borders[$_->att('borderId')]{colors},
            BdrDiag  => $borders[$_->att('borderId')]{diagonal},
            Fill     => $fills[$_->att('fillId')],
        )
    } $styles->find_nodes('//cellXfs/xf');

    return {
        FormatStr => \%format_str,
        Font      => \@font,
        Format    => \@format,
    }
}

sub _extract_files {
    my $self = shift;
    my ($zip) = @_;

    my $type_base =
        'http://schemas.openxmlformats.org/officeDocument/2006/relationships';

    my $rels = $self->_parse_xml(
        $zip,
        $self->_rels_for('')
    );
    my $wb_name = ($rels->find_nodes(
        qq<//Relationship[\@Type="$type_base/officeDocument"]>
    ))[0]->att('Target');
    my $wb_xml = $self->_parse_xml($zip, $wb_name);

    my $path_base = $self->_base_path_for($wb_name);
    my $wb_rels = $self->_parse_xml(
        $zip,
        $self->_rels_for($wb_name)
    );

    my ($strings_xml) = map {
        $zip->memberNamed($path_base . $_->att('Target'))->contents
    } $wb_rels->find_nodes(qq<//Relationship[\@Type="$type_base/sharedStrings"]>);

    my $styles_xml = $self->_parse_xml(
        $zip,
        $path_base . ($wb_rels->find_nodes(
            qq<//Relationship[\@Type="$type_base/styles"]>
        ))[0]->att('Target')
    );

    my %worksheet_xml = map {
        if ( my $sheetfile = $zip->memberNamed($path_base . $_->att('Target'))->contents ) {
            ( $_->att('Id') => $sheetfile );
        }
    } $wb_rels->find_nodes(qq<//Relationship[\@Type="$type_base/worksheet"]>);

    my %themes_xml = map {
        $_->att('Id') => $self->_parse_xml($zip, $path_base . $_->att('Target'))
    } $wb_rels->find_nodes(qq<//Relationship[\@Type="$type_base/theme"]>);

    return {
        workbook => $wb_xml,
        styles   => $styles_xml,
        sheets   => \%worksheet_xml,
        themes   => \%themes_xml,
        ($strings_xml
            ? (strings => $strings_xml)
            : ()),
    };
}

sub _parse_xml {
    my $self = shift;
    my ($zip, $subfile) = @_;

    my $member = $zip->memberNamed($subfile);
    die "no subfile named $subfile" unless $member;

    my $xml = XML::Twig->new;
    $xml->parse(scalar $member->contents);

    return $xml;
}

sub _rels_for {
    my $self = shift;
    my ($file) = @_;

    my @path = split '/', $file;
    my $name = pop @path;
    $name = '' unless defined $name;
    push @path, '_rels';
    push @path, "$name.rels";

    return join '/', @path;
}

sub _base_path_for {
    my $self = shift;
    my ($file) = @_;

    my @path = split '/', $file;
    pop @path;

    return join('/', @path) . '/';
}

sub _dimensions {
    my $self = shift;
    my ($dim) = @_;

    my ($topleft, $bottomright) = split ':', $dim;
    $bottomright = $topleft unless defined $bottomright;

    my ($rmin, $cmin) = $self->_cell_to_row_col($topleft);
    my ($rmax, $cmax) = $self->_cell_to_row_col($bottomright);

    return ($rmin, $cmin, $rmax, $cmax);
}

sub _cell_to_row_col {
    my $self = shift;
    my ($cell) = @_;

    my ($col, $row) = $cell =~ /([A-Z]+)([0-9]+)/;

    my $ncol = 0;
    for my $char (split //, $col) {
        $ncol *= 26;
        $ncol += ord($char) - ord('A') + 1;
    }
    $ncol = $ncol - 1;

    my $nrow = $row - 1;

    return ($nrow, $ncol);
}

sub _color {
    my $self = shift;
    my ($colors, $color_node, $fill) = @_;

    my $color;
    if ($color_node && !$color_node->att('auto')) {
        if (defined $color_node->att('indexed')) {
            # see https://rt.cpan.org/Public/Bug/Display.html?id=93065
            if ($fill && $color_node->att('indexed') == 64) {
                return '#FFFFFF';
            }
            else {
                $color = '#' . Spreadsheet::ParseExcel->ColorIdxToRGB(
                    $color_node->att('indexed')
                );
            }
        }
        elsif (defined $color_node->att('rgb')) {
            $color = '#' . substr($color_node->att('rgb'), 2, 6);
        }
        elsif (defined $color_node->att('theme')) {
            $color = '#' . $colors->[$color_node->att('theme')];
        }

        $color = $self->_apply_tint($color, $color_node->att('tint'))
            if $color_node->att('tint');
    }

    return $color;
}

sub _apply_tint {
    my $self = shift;
    my ($color, $tint) = @_;

    my ($r, $g, $b) = map { oct("0x$_") } $color =~ /#(..)(..)(..)/;
    my ($h, $l, $s) = rgb2hls($r, $g, $b);

    if ($tint < 0) {
        $l = $l * (1.0 + $tint);
    }
    else {
        $l = $l * (1.0 - $tint) + (1.0 - 1.0 * (1.0 - $tint));
    }

    return scalar hls2rgb($h, $l, $s);
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Spreadsheet::ParseXLSX - parse XLSX files

=head1 VERSION

version 0.16

=head1 SYNOPSIS

  use Spreadsheet::ParseXLSX;

  my $parser = Spreadsheet::ParseXLSX->new;
  my $workbook = $parser->parse("file.xlsx");
  # see Spreadsheet::ParseExcel for further documentation

=head1 DESCRIPTION

This module is an adaptor for L<Spreadsheet::ParseExcel> that reads XLSX files.

=head1 METHODS

=head2 new

Returns a new parser instance. Takes no parameters.

=head2 parse($file, $formatter)

Parses an XLSX file. Parsing errors throw an exception. C<$file> can be either
a filename or an open filehandle. Returns a
L<Spreadsheet::ParseExcel::Workbook> instance containing the parsed data.
The C<$formatter> argument is an optional formatter class as described in L<Spreadsheet::ParseExcel>.

=head1 INCOMPATIBILITIES

This module returns data using classes from L<Spreadsheet::ParseExcel>, so for
the most part, it should just be a drop-in replacement. That said, there are a
couple areas where the data returned is intentionally different:

=over 4

=item Colors

In Spreadsheet::ParseExcel, colors are represented by integers which index into
the color table, and you have to use
C<< Spreadsheet::ParseExcel->ColorIdxToRGB >> in order to get the actual value
out. In Spreadsheet::ParseXLSX, while the color table still exists, cells are
also allowed to specify their color directly rather than going through the
color table. In order to avoid confusion, I normalize all color values in
Spreadsheet::ParseXLSX to their string RGB format (C<"#0088ff">). This affects
the C<Fill>, C<BdrColor>, and C<BdrDiag> properties of formats, and the
C<Color> property of fonts. Note that the default color is represented by
C<undef> (the same thing that C<ColorIdxToRGB> would return).

=item Formulas

Spreadsheet::ParseExcel doesn't support formulas. Spreadsheet::ParseXLSX
provides basic formula support by returning the text of the formula as part of
the cell data. You can access it via C<< $cell->{Formula} >>. Note that the
restriction still holds that formula cell values aren't available unless they
were explicitly provided when the spreadsheet was written.

=back

=head1 BUGS

=over 4

=item Large spreadsheets may cause segfaults on perl 5.14 and earlier

This module internally uses XML::Twig, which makes it potentially subject to
L<Bug #71636 for XML-Twig: Segfault with medium-sized document|https://rt.cpan.org/Public/Bug/Display.html?id=71636>
on perl versions 5.14 and below (the underlying bug with perl weak references
was fixed in perl 5.15.5). The larger and more complex the spreadsheet, the
more likely to be affected, but the actual size at which it segfaults is
platform dependent. On a 64-bit perl with 7.6gb memory, it was seen on
spreadsheets about 300mb and above. You can work around this adding
C<XML::Twig::_set_weakrefs(0)> to your code before parsing the spreadsheet,
although this may have other consequences such as memory leaks.

=item Worksheets without the C<dimension> tag are not supported

=item Intra-cell formatting is discarded

=item Diagonal border styles are ignored

=back

In addition, there are still a few areas which are not yet implemented (the
XLSX spec is quite large). If you run into any of those, bug reports are quite
welcome.

Please report any bugs to GitHub Issues at
L<https://github.com/doy/spreadsheet-parsexlsx/issues>.

=head1 SEE ALSO

L<Spreadsheet::ParseExcel>: The equivalent, for XLS files.

L<Spreadsheet::XLSX>: An older, less robust and featureful implementation.

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc Spreadsheet::ParseXLSX

You can also look for information at:

=over 4

=item * MetaCPAN

L<https://metacpan.org/release/Spreadsheet-ParseXLSX>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Spreadsheet-ParseXLSX>

=item * Github

L<https://github.com/doy/spreadsheet-parsexlsx>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Spreadsheet-ParseXLSX>

=back

=head1 SPONSORS

Parts of this code were paid for by

=over 4

=item Socialflow L<http://socialflow.com>

=back

=head1 AUTHOR

Jesse Luehrs <doy@tozt.net>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Jesse Luehrs.

This is free software, licensed under:

  The MIT (X11) License

=cut
