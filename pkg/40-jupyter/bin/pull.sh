#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
osver="$(basename ${PWD%/*/*})"
local_img="pkg:$base"

id=($(docker images "${osver/-/:}.04" --format '{{.ID}}'))
arch="$(docker inspect $id --format '{{.Architecture}}')"
# echo "$arch"
remote_img="$reg/$osver-${local_img}_$arch"
# echo "$img"

if ! remote_created="$(skopeo inspect docker://$remote_img 2> /dev/null | jq --raw-output .Created)"; then
    echo "$remote_img is not found"
    exit 1
fi
echo "$remote_created: $remote_img"

if local_created="$(docker image inspect $local_img --format '{{.Created}}' 2> /dev/null)"; then
    echo "$local_created: $local_img"
    if ! [[ "$local_created" < "$remote_created" ]]; then
        echo "$local_img is newer than or equal to $remote_img"
        exit 0
    fi
fi

docker pull "$remote_img"
docker tag "$remote_img" "$local_img"
exit 0
