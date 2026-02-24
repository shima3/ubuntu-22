docker exec -i ldap search.sh -b "cn=$1,ou=groups,dc=example,dc=local" | awk '/^gidNumber:/{print $2;}'
