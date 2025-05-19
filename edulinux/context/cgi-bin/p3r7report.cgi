#!/bin/bash
echo 'Content-Type: text/plain'
echo
for dir in /home/[a-z]20*/P3R7
do
  pdir=${dir%/*}
  user=${pdir##*/}
  echo $user $dir
done | sort | while read user dir
do
  list=$(cd $dir; ls E[A-Z].class)
  echo -n $user:
  for file in $list
  do echo -n " ${file%.*}.java"
  done
  list=$(cd $dir; ls E[A-Z].py)
  for file in $list
  do echo -n " $file"
  done
  echo
done
exit 0
