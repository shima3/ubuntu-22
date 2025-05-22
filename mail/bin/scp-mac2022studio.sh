#!/bin/bash
cd "${0%/*}"
scp -P 2022 _run.sh exec.sh remove.sh start.sh student@165.242.90.86:ubuntu-22/edulinux/bin
