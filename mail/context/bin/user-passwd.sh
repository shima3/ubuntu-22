#!/bin/bash
USER_ID="$1"
PASS_WORD="$2"
ldappasswd -x -D "cn=admin,dc=example,dc=local" -w "$LDAP_ADMIN_PASSWORD" -H ldap://ldap.internal -s "$PASS_WORD" "uid=$USER_ID,ou=people,dc=example,dc=local"
