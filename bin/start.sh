#!/bin/bash
cd "${0%/*}/.."
docker network create mynet
ldap/start.sh
edulinux/bin/start.sh
