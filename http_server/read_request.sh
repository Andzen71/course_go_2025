#!/bin/bash

function readRequest(){
	while read line; do

		## if line is empty - this is the end of all headers
		trline=`echo $line | tr -d '[\r\n]'`

		[ -z "$trline" ] && break

		HEADLINE_REGEX='(.*?)\s(.*?)\sHTTP.*?'
		[[ "$trline" =~ $HEADLINE_REGEX ]] &&
			REQUEST=$(echo $trline | sed -E "s/$HEADLINE_REGEX/\1 \2/")

		CONTENT_LENGTH_REGEX='Content-Length:\s(.*?)'
		[[ "$trline" =~ $CONTENT_LENGTH_REGEX ]] &&
			CONTENT_LENGTH=`echo $trline | sed -E "s/$CONTENT_LENGTH_REGEX/\1/"`

		COOKIE_REGEX='Cookie:\s(.*?)\=(.*?).*?'
    [[ "$trline" =~ $COOKIE_REGEX ]] &&
      read COOKIE_NAME COOKIE_VALUE <<< $(echo $trline | sed -E "s/$COOKIE_REGEX/\1 \2/")
	done

	## trying to read body
	if [ ! -z "$CONTENT_LENGTH" ]; then
		BODY_REGEX='(.*?)=(.*?)'

		## Read the remaining request body
		while read -n$CONTENT_LENGTH -t1 body; do
			trline=`echo $body| tr -d '[\r\n]'`

			[ -z "$trline" ] && break
			read INPUT_NAME INPUT_VALUE <<< $(echo $trline | sed -E "s/$BODY_REGEX/\1 \2/")

			INPUT_NAME=$(echo $body | sed -E "s/$BODY_REGEX/\1/")
			INPUT_VALUE=$(echo $body | sed -E "s/$BODY_REGEX/\2/")
		done
	fi

}
