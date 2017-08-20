.setUp <- function() {}
.tearDown <- function() {}

test.array <- function()
{
	json <- "[]"
	x <- fromJSON( json )
	checkIdentical( x, list() )

	failing_json <- c( "[", "[12313", "[132,", "[132,1", "[1,5,4,3,", "[1,3}" )
	for( bad_json in failing_json ) {
		x <- try( fromJSON( bad_json ), silent = TRUE )
		checkTrue( any( class( x ) == "try-error" ) )
	}

	json <- "[1]"
	x <- fromJSON( json )
	checkIdentical( x, 1 )

	json <- "[1,5,200]"
	x <- fromJSON( json )
	checkIdentical( x, c(1,5,200) )

	#multiple types are saved as a list
	json <- "[1,5,\"hello\"]"
	x <- fromJSON( json )
	checkIdentical( x, list(1,5,"hello") )

	#test arrays with arrays
	json <- "[[[]],[]]"
	x <- fromJSON( json )
	checkIdentical( x, list( list(list()), list() ) )

	json <- "[null,[]]"
	x <- fromJSON( json )
	checkIdentical( x, list( NULL, list() ) )
}

