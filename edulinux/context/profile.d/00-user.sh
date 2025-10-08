#!/bin/bash
if [ "$USER" == "" ]
then export USER="$(whoami)"
fi
