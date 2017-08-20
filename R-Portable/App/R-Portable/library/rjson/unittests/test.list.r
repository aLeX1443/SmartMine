.setUp <- function() {}
.tearDown <- function() {}

test.list <- function()
{
	json <- "{}"
	x <- fromJSON( json )
	checkIdentical( x, list() )

	failing_json <- c( "{", "{a:5}", "{\"a:5}", "{\"a\":", "{\"a\":5", "{\"a\":}", "{123:false}", "{\"a\":unquoted}" )
	for( bad_json in failing_json ) {
		x <- try( fromJSON( bad_json ), silent = TRUE )
		checkTrue( any( class( x ) == "try-error" ) )
	}

	json <- "{\"a\":5}"
	x <- fromJSON( json )
	checkIdentical( x, list( a = 5 ) )

	json <- "{\"a\":5,\"b\":10}"
	x <- fromJSON( json )
	checkIdentical( x, list( a = 5, b = 10 ) )

	json <- "{\"a\":5,\"b\":10, \"clap\":[true,false,false]}"
	x <- fromJSON( json )
	correct <- list( a = 5, b = 10, clap = c(TRUE,FALSE,FALSE) )
	checkIdentical( x, correct )
	checkIdentical( x[["clap"]], correct[["clap"]] )


}

test.nestedlist <- function()
{
	json <- "[\"a\", [\"b\", \"c\"] ]"
	x <- fromJSON( json )
	correct <- list( "a", c( "b", "c" ) )
	checkIdentical( x, correct )
	checkIdentical( x[[2]], correct[[2]] )
}

test.bad.list <- function()
{
	json <- "{\"a\": 123,}"
	checkException( fromJSON( json ) )
}