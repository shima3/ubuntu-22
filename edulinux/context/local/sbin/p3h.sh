#!/bin/bash
p3r="P3R$(($(date +%Y)-2018))"
day="$(date +%Y/%m/%d)"
cd /home
list=(*/$p3r)
if [ "${list%%/*}" == "*" ]
then exit 0
fi
for dir in "${list[@]}"
do
    user="${dir%%/*}"
    echo "$user"
    bash -c "history -r /home/$user/.bash_history; HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S ' history" | awk '$2=="'$day'"'
done
exit 0
