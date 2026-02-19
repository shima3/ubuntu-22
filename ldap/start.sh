#!/bin/bash
script="$(readlink -f $0)"
dir="${script%/*}"
docker rm -f ldap
docker run -d \
  --name ldap \
  --restart=always \
  -p 389:389 -p 636:636 \
  -v ldap_data:/var/lib/ldap \
  -v ldap_config:/etc/ldap/slapd.d \
  -v $dir:/mnt/ldap \
  -v $HOME/ldap/certs:/container/service/slapd/assets/certs \
  -v $dir/sbin:/usr/local/sbin \
  --env-file $HOME/ldap/env \
  osixia/openldap
