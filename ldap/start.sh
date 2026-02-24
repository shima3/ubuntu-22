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
  -v $dir/sbin:/usr/local/sbin \
  --env-file $HOME/ldap/env \
  --network mynet \
  osixia/openldap

#  -v ldap_certs:/container/service/slapd/assets/certs \
#  -v $HOME/ldap/certs:/container/service/slapd/assets/certs \
#  -v $HOME/ldap/certs:/container/service/slapd/assets/certs:ro \

# cd $HOME/ldap/certs
# docker cp ldap.crt ldap:/container/service/slapd/assets/certs/
# docker cp ldap.key ldap:/container/service/slapd/assets/certs/
# docker cp ca.crt ldap:/container/service/slapd/assets/certs/
