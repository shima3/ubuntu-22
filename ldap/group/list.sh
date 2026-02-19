#!/bin/bash
docker exec -it ldap search.sh -b "ou=groups,dc=example,dc=local"
