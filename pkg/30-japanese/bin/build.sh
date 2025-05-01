#!/bin/bash
PACKAGE="\
  fonts-ipafont fonts-noto-cjk fonts-noto-cjk-extra fonts-takao \
  ibus ibus-mozc \
  language-pack-ja language-pack-ja-base language-pack-gnome-ja \
  libreoffice-help-ja libreoffice-l10n-ja \
  mozc-utils-gui \
  "

# fcitxはインジケーターをクリックするとハングアップする。
# fcitx fcitx-mozc fcitx-anthy fcitx-config-gtk fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt5 fcitx-ui-classic

script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh
../10-xrdp/bin/pull.sh

if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" --file Dockerfile context; then exit 1; fi
if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" --file Dockerfile context; then exit 1; fi

echo -e "\a\a\a"
