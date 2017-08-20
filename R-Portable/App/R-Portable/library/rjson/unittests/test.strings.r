.setUp <- function() {}
.tearDown <- function() {}

test.strings <- function()
{
	json <- "\"\""
	x <- fromJSON( json )
	checkIdentical( x, "" )

	json <- "\"hello world\""
	x <- fromJSON( json )
	checkIdentical( x, "hello world" )

	json <- "\"hello\\ttab\""
	x <- fromJSON( json )
	checkIdentical( x, "hello\ttab" )

	json <- "\"hello\\\"quote\""
	x <- fromJSON( json )
	checkIdentical( x, "hello\"quote" )

	#really long string
	s <- paste( 1:100000, collapse = "-" )
	json <- paste("\"", s, "\"", sep="" )
	x <- fromJSON( json )
	checkIdentical( x, s )
}


