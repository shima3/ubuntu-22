#!/bin/bash
PACKAGE="\
  pdftk poppler-utils printer-driver-cups-pdf \
  xpdf \
  "

# bin="$(dirname $0)"
bin="${0%/*}"
cd "$bin/.."
# base="$(basename $PWD)"
base="${PWD##*/}"
# pkg_base="pkg_$base"
osver="$(basename ${PWD%/*/*})"

# docker images ubuntu
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

# list="$(docker ps --filter ancestor=$base -q)"
# if [ "$list" != "" ]; then docker rm -f "$list"; fi

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage -f Dockerfile context; then exit 1; fi
if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" -f Dockerfile context; then exit 1; fi

# docker-remove-nameless-images
