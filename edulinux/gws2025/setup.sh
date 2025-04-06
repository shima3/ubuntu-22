#!/bin/bash
sudo useradd -m -s /bin/bash -g docker edulinux
bin="$(cd ${0%/*}/../bin; pwd)"
sudo --user edulinux bash $bin/make-forward.sh
