#!/bin/bash
ldapsearch -x -D "cn=admin,dc=example,dc=local" -w "$LDAP_ADMIN_PASSWORD" $*
