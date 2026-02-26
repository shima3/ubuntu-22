#!/bin/bash
cd /etc/sssd
envsubst < sssd.template.conf > sssd.conf
chmod 600 sssd.conf
rm -f /var/lib/sss/db/*
exec sssd $*
