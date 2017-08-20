#!/usr/bin/r --slave
library( "rjson" )
library( "utils" )

#load in any extra sources
source_files <- Sys.getenv( "R_SERVER_SOURCE" )
if( source_files != "" ) {
	source_files <- strsplit( source_files, ":" )[[1]]
	for( s in source_files )
		source( s )
}

#rpc is an R object corresponding to the parsed JSON-RPC call
#returns: a JSON string with the results or error
do.rpc <- function( rpc )
{
	rpc$params <- as.list( rpc$params )

	result <- try( do.call( rpc$method, rpc$params ), silent = TRUE )

	if( class( result ) == "try-error" ) {
		#TODO JSON-RPC defines several erorrs (call not found, invalid params, and server error)
		#if a call exists but fails, I am sending a procedure not found - when really it was found 
		#but had an internal error. the data contains the actual error from R
		rpc_result <- list(
				jsonrpc = "2.0",
				error = list( code = -32601, message = "Procedure not found.", data = as.character( result ) ),
				id = rpc$id
				)
	} else {
		#RPC call suceeded
		rpc_result <- list(
				jsonrpc = "2.0",
				result = result,
				id = rpc$id
				)
	}

	#return the JSON string
	ret <- toJSON( rpc_result )
	ret <- paste( ret, "\n", sep="" )
	return( ret )
}

#requires R 2.5.0
process_stdin <- file("stdin", blocking = T, open = "rb" )
json_parser <- newJSONParser()

while( TRUE ) {

	#TODO read in data in larger chunks
	#when n > 1, readBin sometimes waits until a complete block of n chars is read - piping a flush doesn't always work when n > 1
	s <- readBin( process_stdin, what = raw(), n = 1 )

	#catch an OEF
	if( length( s ) == 0 )
		break
	s <- rawToChar( s )

	#add input to parser buffer
	json_parser$addData( s )
	#Optimization: JSON RPC objects MUST terminate with a `}' - no need to check if the object can be parsed otherwise (since it can't)
	while( s == "}" ) {
		#try to extract any JSON objects
		rpc <- try( json_parser$getObject(), silent = TRUE )
		if( class( rpc ) == "try-error" ) {
			#an error occured
			cat( '{"jsonrpc": "2.0", "error": {"code": -32700, "message": "Parse error"}, "id": null}' )
			#reset JSON parser
			json_parser <- newJSONParser()

			#clear anything on the input
			seek( process_stdin, where = 0, origin = "end" )

		} else {
			#not enough data is in the buffer to extract a complete JSON object	
			if( is.null( rpc ) )
				break

			#a valid JSON object was extracted
			ret <- do.rpc( rpc )
			cat( ret )
		}
	}
}

#must quit here - otherwise, we get dropped into an R shell
q()
