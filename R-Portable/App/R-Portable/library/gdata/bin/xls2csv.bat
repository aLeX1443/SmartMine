REM @echo off
SET PERLPATH= %~dp0\..\perl\
perl %PERLPATH%\xls2csv.pl %*
