#!/bin/bash
host="gws2025.sos.info.hiroshima-cu.ac.jp"
dir="${0%/*}"
cd "$dir"
scp -P 2022 edulinux-start.sh "$host:bin"
scp -P 2022 handle-mail.sh setup.sh make-forward.sh "$host:ubuntu-22/edulinux/bin"
cd "../bin"
scp -P 2022 _run.sh exec.sh remove.sh start.sh ps.sh "$host:ubuntu-22/edulinux/bin"
