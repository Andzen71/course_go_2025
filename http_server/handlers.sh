#!/bin/bash

HTML_PATH="./html"
HTTP_PATH="./http/"

function handle_GET_home() {
  RESPONSE=$(cat $HTML_PATH/home.html | \
    sed "s/{{$COOKIE_NAME}}/$COOKIE_VALUE/")
}

function handle_GET_login() {
  RESPONSE=$(cat $HTML_PATH/login.html)
}

function handle_POST_login() {
  RESPONSE=$(cat $HTTP_PATH/post-login.http | \
    sed "s/{{cookie_name}}/$INPUT_NAME/" | \
    sed "s/{{cookie_value}}/$INPUT_VALUE/")
	echo $RESPONSE
}

function handle_POST_logout() {
  RESPONSE=$(cat $HTTP_PATH/post-logout.http | \
    sed "s/{{cookie_name}}/$COOKIE_NAME/" | \
    sed "s/{{cookie_value}}/$COOKIE_VALUE/")
}

function handle_not_found() {
  RESPONSE=$(cat $HTML_PATH/404.html)
}
