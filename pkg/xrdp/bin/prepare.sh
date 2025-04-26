#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"
reg="kshima"
option="$1"

function inspect(){
    # 最後の引数
    last_arg="${!#}"
    # 最後の引数を除いたそれ以外の引数を配列として取得
    args_except_last=("${@:1:$(($#-1))}")
    IMAGE_ID=($(docker images "$last_arg" --format "{{.ID}}"))
    docker image inspect ${args_except_last[@]} "$IMAGE_ID"
}

local_img="pkg:$base"
echo "local image: $local_img"

local_created="$(inspect --format {{.Created}} $local_img 2> /dev/null)"
echo "local created: $local_created"

arch="$(inspect --format {{.Architecture}} ubuntu)"
echo "arch: $arch"

remote_img="$reg/$osver-pkg:${base}_$arch"
echo "remote image: $remote_img"

# remote_created="$(docker manifest inspect $remote_img 2> /dev/null | jq -r '.manifests[0].digest' | xargs -I {} docker image inspect {} --format '{{.Created}}')"
remote_created="$(skopeo inspect docker://$remote_img 2> /dev/null | jq --raw-output '.Created')"
echo "remote created: $remote_created"

function pull_test(){
    if [[ "$option" == "-u" ]]; then
        [[ "$local_created" < "$remote_created" ]]
    else
        [[ "$local_created" == "" ]]
    fi
}

if [[ "$remote_created" != "" ]]; then
    if pull_test; then
        docker pull "$remote_img"
        docker tag "$remote_img" "$local_img"
    fi
elif [[ "$local_created" == "" ]]; then
    $bin/build.sh
fi
