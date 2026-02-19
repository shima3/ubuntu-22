#!/bin/bash
for user in "$*"
do docker exec -it ldap delete.sh "uid=$user,ou=people,dc=example,dc=local"
done
