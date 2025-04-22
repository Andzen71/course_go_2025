#!/bin/bash

source read_request.sh
source routers.sh
source handlers.sh

### Create the response FIFO
handleRequest() {

	readRequest "$1"
	routers "$REQUEST"

	echo -e "$RESPONSE" > response
}

rm -f response
mkfifo response

echo 'Listening on 3000...'

while true; do
	cat response | nc -lN 3000 | handleRequest
done
