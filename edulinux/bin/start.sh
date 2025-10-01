#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
# bin="${0%/*}"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"
ubuntu_img="${osver/-/:}.04"
# tmpvol="$base-var-tmp"
tmpvol="$base-home"
# tmpdir="/var/tmp"
tmpdir="/home"
# etctar="$tmpdir/etc.tar"
etctar="$tmpdir/.etc.tar"

if ! which jq > /dev/null; then
    echo 'jq: コマンドが見つかりません'
    exit 1
fi

## Ubuntu のアーキテクチャを調べる。
# docker pull "$ubuntu_img"
# arch="$(docker inspect --format '{{.Architecture}}' --type=image $ubuntu_img)"
# edulinux_img="$reg/$osver-$base:$arch"

## /etc/{passwd,shadow,group,gshadow} を $etctar に保存する。
if [[ "$(docker container inspect $base --format '{{json .Mounts}}' | jq --arg name $base-etc '.[] | select(.Name==$name)')" != "" ]]; then
    echo backup: '/etc/{passwd,shadow,group,gshadow} ->' $etctar
    if ! docker run --rm \
    --mount "type=volume,src=$base-etc,dst=/mnt/etc" \
    --mount "type=volume,src=$tmpvol,dst=$tmpdir" \
    "$ubuntu_img" \
    tar cf "$etctar" -C /mnt/etc passwd shadow group gshadow; then
        exit 1
    fi
fi

## 前回起動したコンテナを削除する。
list="$(docker ps --filter name=$base --quiet)"
if [[ "$list" != "" ]]; then
    echo -n "remove $base container "
    docker rm -f "$list"
fi

## ボリューム $base-etc を削除する。
volume="$(docker volume inspect --format '{{.Name}}' $base-etc 2> /dev/null)"
if [ "$volume" != "" ]; then
    echo -n "remove volume: "
    docker volume rm "$base-etc"
fi

# docker pull "$edulinux_img"
$bin/ensure.sh
$bin/_run.sh \
    -dit \
    --restart unless-stopped \
    --mount "type=volume,src=$base-var-log,dst=/var/log" \
    --mount "type=volume,src=$base-var-tmp,dst=/var/tmp" \
    --mount "type=volume,src=$base-backup,dst=/backup" \
    --mount "type=volume,src=$base-etc,dst=/etc" \
    --mount "type=volume,src=$base-home,dst=/home" \
    --ulimit core=0 \
    --tmpfs /run --tmpfs /run/lock \
    --name "$base" \
    -p "0.0.0.0:22:22" \
    $base

#    -p "0.0.0.0:80:80" \
#    "$edulinux_img"
#    -p "0.0.0.0:443:3389"

# docker exec -i "$base" config-apache2.sh "$(hostname)"
hostname="$(hostname)"
docker exec -i "$base" config-apache2.sh "$hostname"
docker exec -i "$base" certbot-apache.sh shima@hiroshima-cu.ac.jp "$hostname"

## $etctar から /etc/{passwd,shadow,group,gshadow} を復元する。
docker exec -i "$base" bash -c "if [ -f $etctar ]; then echo restore: $etctar '-> /etc/{passwd,shadow,group,gshadow}'; tar xf $etctar -C /etc; fi"
