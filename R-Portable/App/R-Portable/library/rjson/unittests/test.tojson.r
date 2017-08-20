.setUp <- function() {}
.tearDown <- function() {}

test.tojson <- function()
{
	x <- 15433
	j <- toJSON( x, "C" )
	checkIdentical( j, "15433" )

	x <- 15.543
	j <- toJSON( x, "C" )
	checkIdentical( j, "15.543" )

	x <- TRUE
	j <- toJSON( x, "C" )
	checkIdentical( j, "true" )

	x <- FALSE
	j <- toJSON( x, "C" )
	checkIdentical( j, "false" )

	x <- NULL
	j <- toJSON( x, "C" )
	checkIdentical( j, "null" )

	#Test strings
	x <- "hello"
	j <- toJSON( x, "C" )
	checkIdentical( j, "\"hello\"" )
	
	x <- "hel\"lo"
	j <- toJSON( x, "C" )
	checkIdentical( j, "\"hel\\\"lo\"" )

	x <- "hel\n"
	j <- toJSON( x, "C" )
	checkIdentical( j, "\"hel\\n\"" )

	x <- "\n\r\t"
	j <- toJSON( x, "C" )
	checkIdentical( j, "\"\\n\\r\\t\"" )

	x <- ""
	j <- toJSON( x, "C" )
	checkIdentical( j, "\"\"" )

	x <- "\u0041\u006c\u0065\u0078\u002B"
	j <- toJSON( x, "C" )
	checkIdentical( j, "\"Alex+\"" )

	x <- "\u018E"
	j <- toJSON( x, "C" )
	checkIdentical( j, "\"\\u018e\"" )

	x <- "\u3020"
	j <- toJSON( x, "C" )
	checkIdentical( j, "\"\\u3020\"" )

	#test arrays
	x <- c(10, 50, 30)
	j <- toJSON( x, "C" )
	checkIdentical( j, "[10,50,30]" )

	x <- list(10, 50, 30)
	j <- toJSON( x, "C" )
	checkIdentical( j, "[10,50,30]" )

	x <- list(10, 50, TRUE)
	j <- toJSON( x, "C" )
	checkIdentical( j, "[10,50,true]" )

	x <- list(10, 50, list())
	j <- toJSON( x, "C" )
	checkIdentical( j, "[10,50,[]]" )

	x <- list(10, 50, NULL)
	j <- toJSON( x, "C" )
	checkIdentical( j, "[10,50,null]" )

	x <- list()
	j <- toJSON( x, "C" )
	checkIdentical( j, "[]" )

	x <- c(T,T,F,F,T,F)
	j <- toJSON( x, "C" )
	checkIdentical( j, "[true,true,false,false,true,false]" )

	#test dicts
	x <- list(key="value")
	j <- toJSON( x, "C" )
	checkIdentical( j, "{\"key\":\"value\"}" )

	x <- c(key="value")
	j <- toJSON( x, "C" )
	checkIdentical( j, "{\"key\":\"value\"}" )

	x <- c(key=TRUE, car=FALSE)
	j <- toJSON( x, "C" )
	checkIdentical( j, "{\"key\":true,\"car\":false}" )

	x <- list(key=TRUE, car=FALSE, apple=c(10.5, 28))
	j <- toJSON( x, "C" )
	checkIdentical( j, "{\"key\":true,\"car\":false,\"apple\":[10.5,28]}" )

	x <- c(a=T,b=F)
	j <- toJSON( x, "C" )
	checkIdentical( j, "{\"a\":true,\"b\":false}" )

}

