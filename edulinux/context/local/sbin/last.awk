#!/usr/bin/awk -f
function iso2jp(iso){
  return substr(iso, 1, 10) " " substr(iso, 12, 8);
}
NF==0{
  exit 0;
}
$4=="-"{
  print $1 "\t" iso2jp($3) "\t" substr($6, 2, 5);
}
$5=="-"{
  print $1 "\t" iso2jp($3) "\t" $6 $7;
}
