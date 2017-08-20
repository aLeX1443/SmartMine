.setUp <- function() {}
.tearDown <- function() {}

test.factors <- function()
{
	x <- as.factor(c("abc", "abc", "dog", "abc"))
	json <- toJSON( x )
	checkIdentical( json, "[\"abc\",\"abc\",\"dog\",\"abc\"]" )
}
