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
    qrcode="/tmp/mailto-$user.png"
    java -cp "$HOME:$HOME/zxing/*" QRCodeGenerator "mailto:$name <$email>" "$qrcode"
    mailx -s "QR code of your email address" -A "$qrcode" "$email" <<EOF
メールアドレスを入力する手間を省くためのQRコードです。
本人や身分を証明するものではありません。
定期試験や学割には使えません。
ただし、公開しない方が無難です。
EOF
fi
exit 0
