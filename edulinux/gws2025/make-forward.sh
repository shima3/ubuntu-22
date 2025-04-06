#!/bin/bash
bin="$(cd ${0%/*}/../bin; pwd)"
echo "\"| $bin/handle-mail.sh\"" > ~/.forward
