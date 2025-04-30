# 未完成
# ログインすると落ちる
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get clean && apt-get update

# for supervisor
RUN apt-get install --no-install-recommends -yqq supervisor sudo
RUN apt-get install -y git make wget tzdata nano less cron \
    unzip lsb-release apt-utils apt-file software-properties-common

ARG PACKAGES="apt-transport-https ca-certificates curl dbus-x11 gawk gnupg2 libfuse2 libx11-dev libxfixes3 libxml2 libxrandr2 openssh-client pulseaudio software-properties-common sudo x11-apps x11-xserver-utils xfonts-base xorgxrdp xrdp xserver-xorg-core xutils zlib1g fuse"
RUN apt-get --fix-missing --yes install $PACKAGES
# RUN apt-get --download-only --fix-missing --no-install-recommends --yes install $PACKAGES

ARG PACKAGES="firefox mate-applets mate-applet-brisk-menu mate-terminal pluma ubuntu-mate-artwork ubuntu-mate-default-settings ubuntu-mate-desktop ubuntu-mate-icon-themes"
RUN apt-get --fix-missing --yes install $PACKAGES

# COPY xrdp-installer-1.5.sh /tmp/installer.sh
# RUN cd tmp && bash installer.sh --sound

ARG PACKAGES="pulseaudio-utils git jq curl libfuse-dev libxfixes-dev libssl-dev libpam0g-dev libtool libjpeg-dev flex bison gettext autoconf libxml-parser-perl xsltproc libxrandr-dev python3-libxml2 nasm pkg-config intltool checkinstall xserver-xorg-dev"
RUN apt-get --fix-missing --yes install $PACKAGES

ARG PACKAGES="libpulse-dev m4 build-essential dpkg-dev libsndfile-dev libcap-dev libjson-c-dev libconfig-dev"
# RUN apt-get install -y $PACKAGES

ARG PACKAGES="mate-desktop-environment-core mate-themes mate-accessibility-profiles mate-calc mate-calc-common mate-hud mate-menu mate-notification-daemon mate-notification-daemon-common mate-utils mate-utils-common ubuntu-mate-icon-themes ubuntu-mate-themes pulseaudio"
RUN apt-get install -yqq $PACKAGES

ARG PACKAGES="libssl-dev libxfixes-dev libjpeg-dev libfuse-dev libfdk-aac-dev libopus-dev libmp3lame-dev libpam0g-dev libxrandr-dev xserver-xorg-dev libpulse-dev m4 intltool dpkg-dev xserver-xorg-core"
RUN apt-get install -yqq $PACKAGES

ARG PACKAGES="firefox mate-terminal pluma ubuntu-mate-artwork ubuntu-mate-default-settings ubuntu-mate-desktop"
RUN apt-get install -yqq $PACKAGES

RUN apt-get install -yqq --fix-missing xrdp

# RUN useradd -m -s /bin/bash -p '$y$j9T$5.GiJT2Bq0FOL4TpxgY410$MZILkvwctSXJx6aWCAdTFbwpHs3Z769y3cUZTFAyWuB' guest
RUN useradd -m -s /bin/bash -p '$6$rVQnyXv7$BTxdnF5N2Uwb/HEN2kGODNeoCf8RxSvsM9SExtd/umz7MNE77LSOB1zffLNM9Bw4X2gtiyBSzdkQ.gCHw2r0L/' guest

COPY start-mate.sh /tmp/

# ------------------------------------
