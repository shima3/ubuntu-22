#!/bin/bash
script="$(readlink -f $0)"
dir="${script%/*}"
docker rm -f ldap
docker run --rm -v $HOME/ldap/certs:/host -v ldap_certs:/volume -w /host ubuntu cp ldap.crt ldap.key ca.crt /volume
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
  -v ldap_certs:/container/service/slapd/assets/certs \
  --network-alias ldap.internal --hostname ldap.internal \
  osixia/openldap

#  --network-alias docker-light-baseimage --hostname docker-light-baseimage \
#  -v ldap_certs:/container/service/slapd/assets/certs \
#  -v $HOME/ldap/certs:/container/service/slapd/assets/certs \
#  -v $HOME/ldap/certs:/container/service/slapd/assets/certs:ro \

# cd $HOME/ldap/certs
# docker cp ldap.crt ldap:/container/service/slapd/assets/certs/
# docker cp ldap.key ldap:/container/service/slapd/assets/certs/
# docker cp ca.crt ldap:/container/service/slapd/assets/certs/
