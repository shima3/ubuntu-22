#!/bin/bash
reg="kshima"
# bin="$(dirname $0)"
bin="${0%/*}"
cd "$bin/.."
# base="$(basename $PWD)"
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

if ! which jq > /dev/null; then
    echo 'jq: コマンドが見つかりません'
    exit 1
fi

ubuntu_img="${osver/-/:}.04"
docker pull "$ubuntu_img"
# docker tag "$ubuntu_img" ubuntu
arch="$(docker inspect --format '{{.Architecture}}' --type=image $ubuntu_img)"
edulinux_img="$reg/$osver-$base:$arch"

# 前回起動したコンテナを削除する。
# list="$(docker ps --all --filter ancestor=$base --quiet)"
list="$(docker ps --filter name=$base --quiet)"
# if docker stop "$base" > /dev/null 2> /dev/null; then echo -n "remove container: "; docker rm "$base"; fi
if [[ "$list" != "" ]]; then
    echo -n "remove $base container "
    docker rm -f "$list"
fi

# /etc/{passwd,shadow,group} を /home/.etc.tar に保存する。
etctar="/home/.etc.tar"
# volume="$(docker volume ls --filter name=$base-etc --quiet)"
volume="$(docker volume inspect --format '{{.Name}}' $base-etc 2> /dev/null)"
if [ "$volume" != "" ]; then
    # if [[ "$(docker inspect --format '{{.Config.Image}}' $base 2> /dev/null)" == "$edulinux_img" ]]; then
    # echo "backup volume: $base-etc"
    echo backup: '/etc/{passwd,shadow,group} ->' $etctar
    # docker exec -i "$base" tar cf "$etctar" -C /etc passwd shadow group
    docker run --rm --mount "type=volume,src=$base-home,dst=/mnt/home" --mount "type=volume,src=$base-etc,dst=/mnt/etc" "$ubuntu_img" tar cf "/mnt/$etctar" -C /mnt/etc passwd shadow group
    echo -n "remove volume: "
    docker volume rm "$base-etc"
fi

# /var/{log,tmp} を $vartar に保存する。
# vartar="/tmp/home/.var.tar"
# volume="$(docker volume inspect --format '{{.Name}}' $base-var 2> /dev/null)"
# if [ "$volume" != "" ]; then
#     echo "backup volume: $base-var"
#     docker run --rm --mount "type=volume,src=$base-home,dst=/tmp/home" --mount "type=volume,src=$base-var,dst=/tmp/var" ubuntu tar cf "$vartar" -C /tmp/var log tmp
#     echo -n "remove volume: "
#     docker volume rm "$base-var"
# fi

docker pull "$edulinux_img"
$bin/_run.sh \
    -dit \
    --restart unless-stopped \
    --mount "type=volume,src=$base-home,dst=/home" \
    --mount "type=volume,src=$base-var-log,dst=/var/log" \
    --mount "type=volume,src=$base-var-tmp,dst=/var/tmp" \
    --mount "type=volume,src=$base-backup,dst=/backup" \
    --mount "type=volume,src=$base-etc,dst=/etc" \
    --ulimit core=0 \
    "$edulinux_img"

#    "$base"

# echo -n 'pause container: '
# docker pause "$base"

# $etctar から /etc/{passwd,shadow,group} を復元する。
# docker run --rm --mount "type=volume,src=$base-home,dst=/tmp/home" --mount "type=volume,src=$base-etc,dst=/tmp/etc" -i ubuntu bash -c "if [ -f $etctar ]; then echo restore volume: $base-etc; rm -fr /tmp/etc/ssh; tar xf $etctar -C /tmp/etc; fi"
docker exec -i "$base" bash -c "if [ -f $etctar ]; then echo restore: $etctar '-> /etc/{passwd,shadow,group}'; tar xf "$etctar" -C /etc; fi"

# $vartar から /var/{log,tmp} を復元する。
# echo "restore volume: $base-var"
# docker run --rm --mount "type=volume,src=$base-home,dst=/tmp/home" --mount "type=volume,src=$base-var,dst=/tmp/var" ubuntu bash -c "if [ -f $vartar ]; then echo restore volume: $base-var; rm -fr /tmp/var/{log,tmp}; tar xf $vartar -C /tmp/var; fi"

# echo -n 'unpause container: '
# docker unpause "$base"

# docker exec -i "$base" bash -c "echo ServerName $(hostname) > /etc/apache2/conf-available/servername.conf"
# docker exec -i "$base" ln -s /etc/apache2/conf-available/servername.conf /etc/apache2/conf-enabled/
# docker exec -i "$base" service apache2 restart
