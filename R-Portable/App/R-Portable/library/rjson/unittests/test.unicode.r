.setUp <- function() {}
.tearDown <- function() {}

test.unicode <- function()
{
	json <- "\"\""
	x <- fromJSON( json )
	checkIdentical( x, "" )

	#test ASCII compatible utf8
	json <- "\"\\u0041\\u006c\\u0065\\u0078\\u002B\""
	x <- fromJSON( json )
	checkIdentical( x, "Alex+", paste( "got:", x ) )

	#test 2 byte utf8 unicode
	json <- "\"\\u018E\""
	x <- fromJSON( json )
	checkIdentical( x, "\u018E" )
	checkTrue( all( charToRaw( x ) == c( 0xc6, 0x8e ) ) )
	checkTrue( length( charToRaw( x ) ) == 2 )

	#test 2 byte utf8 unicode
	json <- "\"\\u018E\""
	x <- fromJSON( json )
	checkIdentical( x, "\u018E" )
	checkTrue( all( charToRaw( x ) == c( 0xc6, 0x8e ) ) )
	checkTrue( length( charToRaw( x ) ) == 2 )

	#test 3 byte utf8 unicode
	json <- "\"\\u3020\""
	x <- fromJSON( json )
	checkIdentical( x, "\u3020" )
	checkTrue( all( charToRaw( x ) == c( 0xe3, 0x80, 0xa0 ) ) )
	checkTrue( length( charToRaw( x ) ) == 3 )

	#x = newJSONParser()
	#x$addData( "\"\\u00" )
	#checkTrue( is.null( x$getObject() ) ) #should be incomplete

}


