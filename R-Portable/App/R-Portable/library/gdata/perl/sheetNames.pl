#!/usr/bin/perl

BEGIN  {
use File::Basename;
# Add current path to perl library search path
use lib dirname($0);
}

use strict;
##
# Try to load the modules we need
##
require 'module_tools.pl';

my(
   $HAS_Spreadsheet_ParseExcel,
   $HAS_Compress_Raw_Zlib,
   $HAS_Spreadsheet_ParseXLSX
  ) = check_modules_and_notify();

use File::Spec::Functions;

# declare some varibles local
my($row, $col, $sheet, $cell, $usage,
   $filename, $volume, $directories, $whoami,
   $basename, $sheetnumber, $filename,
   $text, $parser);


##
## Figure out whether I'm called as sheetCount.pl or sheetNames.pl
##
($volume,$directories,$whoami) = File::Spec->splitpath( $0 );

if($whoami eq "sheetCount.pl")
  {
    $text="number";
  }
elsif ($whoami eq "sheetNames.pl")
  {
    $text="names";
  }
else
  {
    die("This script is named '$whoami', but must be named either 'sheetCount.pl' or 'sheetNames.pl' to function properly.\n");
  }

##
## Usage information
##
$usage = <<EOF;

sheetCount.pl <excel file>

Output is the $text of sheets in the excel file.

EOF

##
## parse arguments
##

if(!defined($ARGV[0]))
  {
    print $usage;
    exit 1;
  }

my $fileName=$ARGV[0];

##
## open spreadsheet
##

open(FH, "<$fileName") or die "Unable to open file '$fileName'.\n";
close(FH);

my $oBook;

## First try as a Excel 2007+ 'xml' file
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


if($whoami eq "sheetCount.pl")
  {
    print $oBook->{SheetCount} , "\n";
  }
elsif ($whoami eq "sheetNames.pl")
  {
    ## Get list all worksheets in the file
    my @sheetlist =  (@{$oBook->{Worksheet}});

    foreach my $sheet (@sheetlist)
      {
	print "\"$sheet->{Name}\" ";
      }

    print "\n";
  }
else
  {
    die("This script is named '$whoami', but must be named either 'sheetCount.pl' or 'sheetNames.pl' to function properly.\n");
  }


