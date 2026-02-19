#!/bin/bash
if [ $# -ne 5 ]
then
    echo "Usage: $0 UID UIDNUM CN GIDNUM PASSWORD"
    exit 0
fi
script="$(readlink -f $0)"
dir="${script%/*}"
# password="$(slappasswd -g)"
# echo "$password"
UID="$1"
UIDNUM="$2"
CN="$3"
SN=${CN%%[ ,　，]*}
GIDNUM="$4"
PASSWORD="$5"
HASH="$($dir/slappasswd.sh -h {SSHA} -s $PASSWORD)"
cat <<EOF | docker exec -i ldap add.sh
dn: uid=$UID,ou=people,dc=example,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
cn: $CN
sn: $SN
uid: $UID
uidNumber: $UIDNUM
gidNumber: $GIDNUM
homeDirectory: /home/$UID
loginShell: /bin/bash
userPassword: $HASH
EOF
