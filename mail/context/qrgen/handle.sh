#!/bin/bash
IFS=$'\n' data=($(awk 'NR==1{print $2;}/^From: /{print substr($0, 7);}' | nkf))
email="${data[0]}"
name="${data[1]% <*}"
domain="${email#*@}"
date "+%F %T%t$email%t$name" >> $HOME/handle.log
chmod g+r $HOME/handle.log
if [[ "$domain" == "micron.com" || "$domain" =~ .hiroshima-cu.ac.jp || "$domain" == "hiroshima-cu.ac.jp" ]]
then
    user="${email%@*}"
    java -cp "$HOME:$HOME/zxing/*" QRCodeGenerator "mailto:$email" "/tmp/$user.png"
    echo "hoge" | mailx -s "hoge" -A "/tmp/$user.png" "$email"
fi
exit 0
