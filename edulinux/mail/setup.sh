#!/bin/bash
sudo useradd -m -s /bin/bash -g docker edulinux
bin="$(cd ${0%/*}; pwd)"
sudo --user edulinux bash $bin/forward.sh
