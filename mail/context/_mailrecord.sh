#!/bin/bash
trim(){
    if [[ $1 =~ ^[[:space:]]*(.*)[[:space:]]*$ ]]
    then
	echo "${BASH_REMATCH[1]}"
    else
	echo "$line"
    fi
}

unify_mail_header_fields(){
    last=
    while IFS= read -r line
    do
	if [[ $line =~ ^[[:space:]] ]]
	then
	    last="$last $(trim "$line")"
	else
	    if [[ ! $last = "" ]]
	    then
		echo "$last"
	    fi
	    if [[ $line = "" ]]
	    then
		break
	    fi
	    last="$line"
	fi
    done
}

read_mail_header(){
    IFS=$'\n' mail_header=($(unify_mail_header_fields))
}

get_mail_header_field_value(){
    for field in ${mail_header[@]}
    do
	if [[ "${field%%: *}" = "$1" ]]
	then
	    trim "${field#*: }"
	fi
    done
}

date=(`date "+%Y%m%d %H%M%S"`)
dir=~/MailRecord/${date[0]}
mkdir -p $dir
cd $dir
IFS=$'\n' mail_header=($(tee $$ | unify_mail_header_fields))
from=$(get_mail_header_field_value From)
subject=$(get_mail_header_field_value Subject)
if [[ $from =~ ([^ @<]*)@ ]]
then
  file=${date[1]}_${BASH_REMATCH[1]}
else
  file=${date[1]}_$$
fi
echo -e "$file" "\t" "$from" "\t" "$subject" | nkf -w >> list
mv $$ $file
