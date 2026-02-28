#!/bin/bash
if [ $# -ne 7 ]
then
    echo "Usage: $0 GROUP_ID HOME_ROOT SHELL MAIL_DOMAIN UIDNUM UID USER_NAME"
    exit 0
fi
GROUP_ID="$1"
HOME_ROOT="$2"
SHELL="$3"
MAIL_DOMAIN="$4"
UIDNUM="$5"
USER_ID="$6"
USER_NAME="$7"

script="$(readlink -f $0)"
dir="${script%/*}"

SN="${USER_NAME%%[ ,　，]*}"
GIDNUM="$($dir/group-idnum.sh $GROUP_ID)"
# PASSHASH="$($dir/pass-hash.sh "$PASSWORD")"

cat <<EOF | ldapadd -x -D "cn=admin,dc=example,dc=local" -w "$LDAP_ADMIN_PASSWORD" -H ldap://ldap.internal
dn: uid=$USER_ID,ou=people,dc=example,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
cn: $USER_NAME
sn: $SN
uid: $USER_ID
uidNumber: $UIDNUM
gidNumber: $GIDNUM
homeDirectory: $HOME_ROOT/$USER_ID
loginShell: $SHELL
mail: $USER_ID@$MAIL_DOMAIN
shadowLastChange: 0
shadowMin: 0
shadowMax: 99999
shadowWarning: 7
EOF
