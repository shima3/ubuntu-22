#!/bin/bash
# printenv >> $HOME/handle.log
LANG="ja_JP.UTF-8"
IFS=$'\n' data=($(awk 'NR==1{print $2;}/^From: /{print substr($0, 7);}' | nkf))
email="${data[0]}"
name="${data[1]% <*}"
domain="${email#*@}"
date "+%F %T%t$email%t$name" >> $HOME/handle.log
chmod g+r $HOME/handle.log
if [[ "$domain" == "micron.com" || "$domain" =~ .hiroshima-cu.ac.jp || "$domain" == "hiroshima-cu.ac.jp" ]]
then
    user="${email%@*}"
    text="mailto:$name <$email>"
    qrcode="/tmp/mailto-$user.png"
    java -cp "$HOME:$HOME/zxing/*" QRCodeGenerator "$text" "$qrcode"
    mailx -s "QR code of $text" -A "$qrcode" -a "From: QR code generator <$RECIPIENT>" "$email" <<EOF
あなたのメールアドレスを入力するためのQRコードを添付しました。
本人や身分を証明するものではありません。
例えば、定期試験や学割には使えません。
しかし、他人には必要もなく見せない方が無難です。
EOF
fi
exit 0
