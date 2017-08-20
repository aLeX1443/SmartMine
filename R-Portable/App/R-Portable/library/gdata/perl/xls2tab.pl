#!/usr/bin/perl

BEGIN {
  use File::Basename;
  # Add current path to perl library search path
  use lib dirname($0);
}

use strict;
#use Spreadsheet::ParseExcel;
#use Spreadsheet::ParseXLSX;
use File::Spec::Functions;
use Getopt::Std;

##
# Try to load the modules we need
##
require 'module_tools.pl';
my(
   $HAS_Spreadsheet_ParseExcel,
   $HAS_Compress_Raw_Zlib,
   $HAS_Spreadsheet_ParseXLSX
  ) = check_modules_and_notify();

# declare some varibles local
my($row, $col, $sheet, $cell, $usage,
   $targetfile,$basename, $sheetnumber,
   $filename, $volume, $directories, $whoami,
   $sep, $sepName, $sepLabel, $sepExt,
   $skipBlankLines, %switches,
   $parser, $oBook, $formatter,
   $using_1904_date
);

##
## Figure out whether I'm called as xls2csv.pl or xls2tab.pl
##
($volume,$directories,$whoami) = File::Spec->splitpath( $0 );

if($whoami eq "xls2csv.pl")
  {
    $sep=",";
    $sepName="comma";
    $sepLabel="CSV";
    $sepExt="csv";

  }
elsif ($whoami eq "xls2tsv.pl")
  {
    $sep="\t";
    $sepName="tab";
    $sepLabel="TSV";
    $sepExt="tsv";
  }
elsif ($whoami eq "xls2tab.pl")
  {
    $sep="\t";
    $sepName="tab";
    $sepLabel="TAB";
    $sepExt="tab";
  }
else
  {
    die("This script is named '$whoami', but must be named 'xls2csv.pl', 'xls2tsv', or 'xls2tab.pl' to function properly.\n");
  }


##
## Usage information
##
$usage = <<EOF;

$whoami [-s] <excel file> [<output file>] [<worksheet number>]

Translate the Microsoft Excel spreadsheet file contained in <excel
file> into $sepName separated value format ($sepLabel) and store in
<output file>, skipping blank lines unless "-s" is present.

If <output file> is not specified, the output file will have the same
name as the input file with '.xls', or 'xlsx' removed and '.$sepExt'
appended.

If no worksheet number is given, each worksheet will be written to
a separate file with the name '<output file>_<worksheet name>.$sepExt'.

EOF

##
## parse arguments
##

# Handle switches (currently, just -s)
getopts('s', \%switches);
$skipBlankLines=!$switches{s};

# Now the rest of the arguments

if( !defined($ARGV[0]) )
  {
    print $usage;
    exit 1;
  }

if( defined($ARGV[1]) )
   {
     $basename = $targetfile = $ARGV[1];
     $basename =~ s/\.$sepExt$//i;
   }
else
   {
     ($volume,$directories,$basename) = File::Spec->splitpath( $ARGV[0] );
     $basename =~ s/\.xlsx*//i;
   }

my $targetsheetname;
my $sheetnumber;

if(defined($ARGV[2]) )
  {
    if ( $ARGV[2] =~ m|^\d+$| )
      {
	$sheetnumber = $ARGV[2];
	die "Sheetnumber must be an integer larger than 0.\n" if $sheetnumber < 1;
      }
    else
      {
	$targetsheetname = $ARGV[2];
      }
  }

##
## open spreadsheet
##

my $oExcel;
my $oBook;

$oExcel    = new Spreadsheet::ParseExcel;
$formatter = Spreadsheet::ParseExcel::FmtDefault->new();

open(FH, "<$ARGV[0]") or die "Unable to open file '$ARGV[0]'.\n";
close(FH);

print "\n";
print "Loading '$ARGV[0]'...\n";
## First try as a Excel 2007+ 'xml' file
eval
  {
    local $SIG{__WARN__} = sub {};
    $parser = Spreadsheet::ParseXLSX -> new();
    $oBook = $parser->parse ($ARGV[0]);
  };
## Then Excel 97-2004 Format
if ( !defined $oBook )
  {
    $parser = Spreadsheet::ParseExcel -> new();
    $oBook = $parser->parse($ARGV[0]) or \
      die "Error parsing file '$ARGV[0]'.\n";
  }
print "Done.\n";

## Does this file use 1904-01-01 as the reference date instead of
## 1900-01-01?
$using_1904_date = ( $oBook->using_1904_date() == 1 ) || # ParseExcel
                   ( $oBook->{Flag1904}        == 1 );   # ParseXLSX


## Show the user some summary information before we start extracting
## date
print "\n";
print "Orignal Filename: ", $ARGV[0], "\n";
print "Number of Sheets: ", $oBook->{SheetCount} , "\n";
if($using_1904_date)
  {
      print "Date reference  : 1904-01-01\n";
  }
else
  {
      print "Date reference  : 1900-01-01\n";
  }

print "\n";

## Get list all worksheets in the file
my @sheetlist =  (@{$oBook->{Worksheet}});
my $sheet;

## If we want a specific sheet drop everything else
if ( defined($sheetnumber) )
  {
    $sheet = $oBook->Worksheet($sheetnumber-1) or die "No sheet number $sheetnumber.\n";
    @sheetlist = ( $sheet  );

  }
elsif ( defined($targetsheetname) )
  {
    $sheet = $oBook->Worksheet($targetsheetname) or die "No sheet named '$targetsheetname'.\n";
    @sheetlist = ( $sheet  );
  }


##
## iterate across each worksheet, writing out a separat csv file
##

my $i=0;
my $sheetname;
my $found=0;
foreach my $sheet (@sheetlist)
{
  $i++;


  $sheetname = $sheet->{Name};

  if( defined($sheetnumber) || defined($targetsheetname) || $oBook->{SheetCount}==1 )
    {
      if( defined($targetfile) )
	{
	  $filename = $targetfile;
	}
      else
	{
	  $filename = "${basename}.$sepExt";
	}
    }
  else
    {
      $filename = "${basename}_${sheetname}.$sepExt";
    }

  if( defined($sheetnumber) )
    {
      print "Writing sheet number $sheetnumber ('$sheetname') to file '$filename'\n";
    }
  elsif ( defined($targetsheetname) )
    {
      print "Writing sheet '$sheetname' to file '$filename'\n";
    }
  else
    {
      print "Writing sheet number $i ('$sheetname') to file '$filename'\n";
    }

  open(OutFile,">$filename");

  my $cumulativeBlankLines=0;

  my $minrow = $sheet->{MinRow};
  my $maxrow = $sheet->{MaxRow};
  my $mincol = $sheet->{MinCol};
  my $maxcol = $sheet->{MaxCol};

  print "Minrow=$minrow Maxrow=$maxrow Mincol=$mincol Maxcol=$maxcol\n";

  for(my $row =  $minrow; $row <= $maxrow; $row++)
    {
       my $outputLine = "";

       for(my $col = $mincol; $col <= $maxcol; $col++)
         {
           my $cell   = $sheet->{Cells}[$row][$col];
	   my $format = $formatter->FmtString($cell, $oBook);
	   if( defined($cell) )
	      {
		  if ($cell->type() eq "Date") # && $using_1904_date )
		    {
			my $is_date = ( $format =~ m/y/ &&
					$format =~ m/m/ &&
					$format =~ m/d/ );

			my $is_time = ( $format =~ m/h[:\]]*m/ ||
					$format =~ m/m[:\]]*s/ );


			if($is_date && $is_time)
			  {
			      $format = "yyyy-mm-dd hh:mm:ss.00";
			  }
			elsif ($is_date)
			  {
			      $format = "yyyy-mm-dd";
			  }
			elsif ($is_time)
			  {
			      $format = "hh:mm:ss.00"
			  }

			$_ = ExcelFmt($format,
				      $cell->unformatted(),
				      $using_1904_date);
		    }
		  else
		    {
		      $_=$cell->value();
		    }

		# convert '#NUM!' strings to missing (empty) values
		s/#NUM!//;

		# convert "#DIV/0!" strings to missing (emtpy) values
                s|#DIV/0!||;

		# escape double-quote characters in the data since
		# they are used as field delimiters
		s/\"/\\\"/g;
	      }
	   else
	     {
	       $_ = '';
	     }

	   $outputLine .= "\"" . $_ . "\"" if(length($_)>0);

	   # separate cells with specified separator
	   $outputLine .= $sep if( $col != $maxcol) ;

         }

       # skip blank/empty lines
       if( $skipBlankLines && ($outputLine =~ /^[$sep ]*$/) )
       	 {
       	   $cumulativeBlankLines++
       	 }
       else
       	 {
	   print OutFile "$outputLine\n"
	 }
     }

  close OutFile;

  print "  (Ignored $cumulativeBlankLines blank lines.)\n"
      if $skipBlankLines;
  print "\n";
}

