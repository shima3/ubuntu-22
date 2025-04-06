#!/bin/bash
bin="$(cd ${0%/*}; pwd)"
echo "\"| $bin/handle-mail.sh\"" > ~/.forward
