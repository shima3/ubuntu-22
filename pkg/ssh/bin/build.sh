#!/bin/bash
PACKAGE="openssh-server"

# bin="$(dirname $0)"
# cd "$bin/.."
# base="$(basename $PWD)"
# pkg_base="pkg_$base"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

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

if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" --file Dockerfile context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" --file Dockerfile context; then exit 1; fi

# docker-remove-nameless-images
