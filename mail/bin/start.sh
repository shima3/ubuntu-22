#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
# base="${PWD##*/}"
base="mail"
osver="$(basename ${PWD%/*})"
ubuntu_img="${osver/-/:}.04"
tmpvol="$base-home"
tmpdir="/home"
etctar="$tmpdir/.etc.tar"

# if ! which jq > /dev/null; then echo 'jq: コマンドが見つかりません'; exit 1; fi

## 前回起動したコンテナを削除する。
list="$(docker ps --all --filter name=$base --quiet)"
if [[ "$list" != "" ]]; then echo -n "remove $base container "; docker rm --force "$list"; fi

$bin/_run.sh \
    -dit \
    --restart unless-stopped \
    --ulimit core=0 \
    --tmpfs /run --tmpfs /run/lock \
    --name "$base" \
    "$base"

#    --mount "type=bind,src=/Volumes/Sync/Backup/MailRecord,dst=/home/_mailrecord/MailRecord" \

docker cp $HOME/mail/sender_canonical mail:/etc/postfix/
docker cp $HOME/mail/header_checks mail:/etc/postfix/
docker exec "$base" chown root.root /etc/postfix/{sender_canonical,header_checks}
docker exec "$base" postmap /etc/postfix/sender_canonical
docker exec "$base" postconf -e "sender_canonical_maps = hash:/etc/postfix/sender_canonical"
docker exec "$base" postconf -e "smtp_header_checks = regexp:/etc/postfix/header_checks"
docker exec "$base" postfix reload

# docker exec "$base" useradd --gid users --no-user-group --shell /bin/bash --uid "$(id -u)" --create-home "$USER"
# docker exec "$base" usermod --create-home "$USER"
# --password '$y$j9T$TZI2qVVjbYATACN2brqSa1$d3ClHj/6yTbHWW4asITrfGWelSjyr2BFxlpz5DA1DIC'
# $y$j9T$whNZTgxbGdeIJuWEUSkJA0$0fr5b1BLfAbV4qd8GMzM8JOg5vle2spWcuUI3xW9jCD
