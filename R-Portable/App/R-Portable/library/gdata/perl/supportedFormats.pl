#!/usr/bin/perl

BEGIN {
  use File::Basename;
  # Add current path to perl library search path
  use lib dirname($0);
}

require 'module_tools.pl';

my( $HAS_Spreadsheet_ParseExcel,
    $HAS_Compress_Raw_Zlib,
    $HAS_Spreadsheet_ParseXLSX) = check_modules(0);

$XLS_Support  = $HAS_Spreadsheet_ParseExcel;
$XLSX_Support = $HAS_Spreadsheet_ParseExcel &&
                $HAS_Compress_Raw_Zlib &&
                $HAS_Spreadsheet_ParseXLSX;

printf "Supported formats: ";
printf "XLS " if ( $XLS_Support );
printf "XLSX" if ( $XLSX_Support );
printf "\n";



