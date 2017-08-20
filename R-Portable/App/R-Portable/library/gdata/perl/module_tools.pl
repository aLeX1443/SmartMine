#!/usr/bin/perl

BEGIN {
  use File::Basename;
  # Add current path to perl library search path
  use lib dirname($0);
}

use strict;
use warnings;
use Data::Dumper;
use Cwd;

sub check_modules(;$)
  {
    my(
       $VERBOSE, 
       $HAS_Spreadsheet_ParseExcel,
       $HAS_Compress_Raw_Zlib,
       $HAS_Spreadsheet_ParseXLSX
      );
    $VERBOSE=$_[0];

    # Check if we can load the libraries we need
    eval
      {
        require Spreadsheet::ParseExcel;
	use Spreadsheet::ParseExcel::Utility qw(ExcelFmt);
        $HAS_Spreadsheet_ParseExcel=1;
        print "Loaded Spreadsheet::ParseExcel\n" if $VERBOSE;
      };
    eval
      {
        require Compress::Raw::Zlib;
        $HAS_Compress_Raw_Zlib=1;
        print "Loaded Compress::Raw::Zlib\n" if $VERBOSE;
      };
    eval
      {
        require Spreadsheet::ParseXLSX;
        $HAS_Spreadsheet_ParseXLSX=1;
        print "Loaded Spreadsheet::ParseXLSX\n" if $VERBOSE;
      };

    if($VERBOSE)
      {
        print "ERROR: Unable to load Spreadsheet::ParseExcel perl module! \n"
	  if !$HAS_Spreadsheet_ParseExcel;
        print "ERROR: Unable to load Compress::Raw::Zlib perl module! \n"
	  if ! $HAS_Compress_Raw_Zlib;
        print "ERROR: Unable to load Spreadsheet::ParseXLSX perl module! \n"
	  if ! $HAS_Spreadsheet_ParseXLSX;
      }

    return $HAS_Spreadsheet_ParseExcel, $HAS_Compress_Raw_Zlib, $HAS_Spreadsheet_ParseXLSX;
  }

sub check_modules_and_notify()
  {
    my( 
       $HAS_Spreadsheet_ParseExcel,
       $HAS_Compress_Raw_Zlib,
       $HAS_Spreadsheet_ParseXLSX) = check_modules(0);

    $HAS_Spreadsheet_ParseExcel or
      die("ERROR: Perl module Spreadsheet::ParseExcel cannot be loaded. Exiting.\n");

    $HAS_Compress_Raw_Zlib or
      warn("WARNING: Perl module Compress::Raw::Zlib cannot be loaded.\n");

    $HAS_Spreadsheet_ParseXLSX or
      warn("WARNING: Perl module Spreadsheet::ParseXLSX cannot be loaded.\n");

    ($HAS_Compress_Raw_Zlib && $HAS_Spreadsheet_ParseXLSX ) or
      warn("WARNING: Microsoft Excel 2007 'XLSX' formatted files will not be processed.\n");
    return $HAS_Spreadsheet_ParseExcel, $HAS_Compress_Raw_Zlib, $HAS_Spreadsheet_ParseXLSX;
  }

sub install_modules()
  {
    my($mod, $obj, $here);

    $here = dirname($0);

    # load the module
    require CPAN;

    # initialize CPAN components
    CPAN::HandleConfig->load();
    CPAN::Shell::setup_output();
    CPAN::Index->reload();

    # set the target install path
    CPAN::Shell->o("conf", "mbuildpl_arg", 
		   "PREFIX=$here LIB=$here --prefix $here --install-base $here");
    CPAN::Shell->o("conf", "makepl_arg", 
		   "PREFIX=$here LIB=$here --prefix $here --install-base $here");
    CPAN::Shell->install("Compress::Raw::Zlib");

    #return 0;

    # install the libraries we want
    for $mod (qw( Compress::Raw::Zlib Spreadsheet::ParseXLSX )){
        my $obj = CPAN::Shell->expand('Module',$mod);
        $obj->install;
    }

  }

1;
