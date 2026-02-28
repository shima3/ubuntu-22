#!/bin/bash
ldapsearch -x -D "cn=admin,dc=example,dc=local" -w "$LDAP_ADMIN_PASSWORD" -b "ou=people,dc=example,dc=local" -H ldap://ldap.internal $*
