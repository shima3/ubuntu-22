#!/bin/bash
cd "${0%/*}"
scp -P 22 _run.sh exec.sh remove.sh start.sh gdep2021.sos.info.hiroshima-cu.ac.jp:ubuntu-22/edulinux/bin
