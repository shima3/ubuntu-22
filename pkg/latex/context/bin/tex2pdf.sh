#!/bin/bash
basename=$1
error( ){
    cat $1
    echo Error
    exit 1
}
for pdfname in fig/*.pdf
do if [[ ! "$pdfname" =~ -crop.pdf$ ]]
    then pdfbasename="${pdfname%.*}"
	if [[ $pdfname -nt $pdfbasename-crop.pdf ]]
	then
	    pdfcrop --pdfversion none $pdfname
	fi
    fi
done
rm -f $basename.bbl $basename.log
export LC_CTYPE=ja_JP.UTF-8
echo platex $basename
# platex -shell-escape -halt-on-error -file-line-error $name > /dev/null || error $name.log
platex -shell-escape -halt-on-error -interaction=nonstopmode -file-line-error $basename > /dev/null 2>&1 || error $basename.log
echo pbibtex $basename
# pbibtex $basename > /dev/null || error $basename.blg
pbibtex $basename > /dev/null
platex -halt-on-error -file-line-error $basename > /dev/null 2>&1 || error $basename.log
platex -halt-on-error -file-line-error $basename > /dev/null 2>&1 || error $basename.log
if dvipdfmx $basename
then pdffonts $basename.pdf
fi
# grep Warning $basename.log
exit 0
