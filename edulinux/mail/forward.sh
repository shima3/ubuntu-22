#!/bin/bash
bin="$(cd ${0%/*}; pwd)"
echo "\"| flock --timeout 60 $HOME/handle.log.lock bash $bin/handle.sh\"" > ~/.forward
