#!/bin/bash
USER_ID="$1"
ldapdelete -x -D "cn=admin,dc=example,dc=local" -w "$LDAP_ADMIN_PASSWORD" "uid=$USER_ID,ou=people,dc=example,dc=local" -H ldap://ldap.internal
