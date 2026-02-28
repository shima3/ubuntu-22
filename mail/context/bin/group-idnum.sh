#!/bin/bash
ldapsearch -x -D "cn=admin,dc=example,dc=local" -w "$LDAP_ADMIN_PASSWORD" -b "cn=$1,ou=groups,dc=example,dc=local" -H ldap://ldap.internal | awk '/^gidNumber:/{print $2;}'
