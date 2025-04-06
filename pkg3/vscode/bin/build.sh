#!/bin/bash
# bin="$(dirname $0)"
# cd "$bin/.."
# base="$(basename $PWD)"
# pkg_base="pkg_$base"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

# OSVersion="$(docker inspect --format '{{json .Config.Labels}}' --type=image ubuntu:latest | jq --raw-output --join-output '.["org.opencontainers.image.ref.name"], .["org.opencontainers.image.version"]')"
Architecture="$(docker inspect --format '{{.Architecture}}' ubuntu:latest)"
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
if [ "$list" != "" ]; then docker rm -f "$list"; fi

cd context
rm vscode.deb
ln -s code_*_${Architecture}.deb vscode.deb
cd ..

if ! docker build --tag "test:$base" --target test-stage -f Dockerfile context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" -f Dockerfile context; then exit 1; fi

# docker-remove-nameless-images
exit 0
