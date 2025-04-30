#!/bin/bash

function check(){
    echo "check $1"
    dpkg -l | awk -v pkg="$1" '$2==pkg'
}

for pkg in pdftk poppler-utils printer-driver-cups-pdf xpdf
do check $pkg
done
