@ECHO OFF
SET ROPTS=--no-save --no-environ --no-init-file --no-restore --no-Rconsole
mode 110,37
R-Portable\App\R-Portable\bin\Rscript.exe %ROPTS% Mining\scripts\Mining-v0.4.6.3.R
pause