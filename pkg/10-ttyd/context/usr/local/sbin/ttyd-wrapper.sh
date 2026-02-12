#!/bin/sh
USER=$(echo "$HTTP_X_REMOTE_USER")
if [ "$USER" == "" ]
then exec login
else exec su - "$USER"
fi
