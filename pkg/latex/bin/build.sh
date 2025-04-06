#!/bin/bash
PACKAGE="\
  texlive \
  texlive-latex-recommended texlive-latex-extra \
  texlive-fonts-recommended texlive-bibtex-extra \
  texlive-lang-japanese \
  perl-tk \
  "

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

# list="$(docker ps --filter ancestor=$base -q)"
# if [ "$list" != "" ]; then docker rm -f "$list"; fi

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage -f Dockerfile context; then exit 1; fi
if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" -f Dockerfile context; then exit 1; fi

# docker-remove-nameless-images
exit 0
