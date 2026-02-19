#!/bin/bash
for group in "$*"
do docker exec -it ldap delete.sh "cn=$group,ou=groups,dc=example,dc=local"
done
