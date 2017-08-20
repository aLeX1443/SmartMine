require( "stats", quietly = TRUE )

user_func <- function( times ) {
	rep( "I am made of sugar", times )
}

fib <- function( n ) {
	if( n < 2 )
		return( 1 )
	return( fib( n - 1 ) + fib( n - 2 ) )
}
