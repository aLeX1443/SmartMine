#R reads in R_PROFILE first - which will start up the server.r script, which then sources in anything from R_SERVER_SOURCE
#R_SERVER_SOURCE is a colon delimited list of user source files to read in
set R_PROFILE=server.r
set R_SERVER_SOURCE=%1

set Path=.;C:\Program Files\R\R-2.9.0\bin\
r --slave --silent
