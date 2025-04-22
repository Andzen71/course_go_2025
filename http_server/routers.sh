#!/bin/bash

source handlers.sh

function routers(){
	REQUEST=$1
	case "$REQUEST" in
		"GET /login")   handle_GET_login ;;
		"GET /")        handle_GET_home ;;
		"POST /login")  handle_POST_login ;;
		"POST /logout") handle_POST_logout ;;
		*)              handle_not_found ;;
	esac
}
