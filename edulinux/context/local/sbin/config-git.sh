#!/bin/bash
email=$1
read -r name
cd
if [ -e .gitconfig ]
then exit 0
fi
echo '[user]' > .gitconfig
echo -e "\temail = $email" >> .gitconfig
echo -e "\tname = $name" >> .gitconfig
echo '[init]' >> .gitconfig
echo -e "\tdefaultBranch = main" >> .gitconfig
