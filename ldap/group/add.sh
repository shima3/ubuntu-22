#!/bin/bash
if [ $# -ne 2 ]
then
    echo "Usage: $0 GID GIDNUM"
    exit 0
fi
GID=$1
GIDNUM=$2
cat <<EOF | docker exec -i ldap add.sh
dn: cn=$GID,ou=groups,dc=example,dc=local
objectClass: posixGroup
cn: $GID
gidNumber: $GIDNUM
EOF
