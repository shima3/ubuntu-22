#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"
ubuntu_img="${osver/-/:}.04"
tmpvol="$base-home"
tmpdir="/home"
etctar="$tmpdir/.etc.tar"

$bin/ensure.sh
$bin/_run.sh \
    -dit \
    --restart unless-stopped \
    --mount "type=volume,src=edulinux-etc,dst=/etc" \
    --mount "type=volume,src=edulinux-home,dst=/home" \
    --mount "type=volume,src=$base-var,dst=/var" \
    --mount "type=volume,src=$base-etc-letsencrypt,dst=/etc/letsencrypt" \
    --mount "type=volume,src=$base-etc-apache2,dst=/etc/apache2" \
    --ulimit core=0 \
    --tmpfs /run --tmpfs /run/lock \
    --name "$base" \
    $base

#    --mount "type=volume,src=$base-var-log,dst=/var/log" \
#    --mount "type=volume,src=$base-var-tmp,dst=/var/tmp" \
#    --mount "type=volume,src=$base-var-lib-letsencrypt,dst=/var/lib/letsencrypt" \
#    --mount "type=volume,src=$base-backup,dst=/backup" \
#    "$edulinux_img"
#    -p "0.0.0.0:443:3389"

hostname="$(hostname)"
docker exec -i "$base" config-apache2.sh "$hostname"
docker exec -i "$base" certbot-apache.sh shima@hiroshima-cu.ac.jp "$hostname"
