#!/bin/bash
user=$1
pw=$2
if [ "$user" == "" ]
then
    echo "Usage: ${0##*/} LOGIN [PASSWORD]"
    exit 0
fi
useradd -g users -m --key HOME_MODE=0755 -s /bin/bash $user
if [ "$pw" == "" ]
then pw=$(pwgen -Bs1)
fi
echo $user:$pw | chpasswd
echo $pw
