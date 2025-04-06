#!/bin/bash
# bin=$(dirname $0)
# cd "$bin/.."
cd "${0%/*}/.."
# base="$(basename $PWD)"
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

# ubuntu="ubuntu:22.04"
# docker pull "$ubuntu"
# docker tag "$ubuntu" ubuntu

img="${osver/-/:}.04"
docker pull "$img"
docker tag "$img" ubuntu

# OSVersion="$(docker inspect --format '{{json .Config.Labels}}' --type=image ubuntu:latest | jq --raw-output --join-output '.["org.opencontainers.image.ref.name"], .["org.opencontainers.image.version"]')"
# Architecture="$(docker inspect --format '{{.Architecture}}' --type=image ubuntu:latest)"
# if [ "$OSVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi

# tag="${OSVersion%%.*}$Architecture"
function inspect_created(){
    docker inspect $1 --format '{{.Created}}' 2> /dev/null
}
function pkg_pull(){
    remote="kshima/pkg_$1:$tag"
    docker pull $remote
    remote_created="$(inspect_created $remote)"
    local="pkg_$1"
    local_created="$(inspect_created $local)"
    if [[ "$remote_created" > "$local_created" ]]; then
        echo "Pull: $remote > $local"
        docker tag "$remote" "$local"
    else
        echo "Skip: $remote <= $local"
    fi
}
# for pkg in $(awk '/^COPY --from=pkg_/{ print substr($2, 12); }' Dockerfile); do pkg_pull $pkg; done

list="$(docker ps --filter ancestor=$base -q)"
if [ "$list" != "" ]; then docker stop $list; fi

docker build --tag "$base" --label "OS-Ver=$osver" --file Dockerfile context

# docker-remove-nameless-images

echo -e "\a\a\a"
