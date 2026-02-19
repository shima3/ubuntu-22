#!/bin/bash
docker exec -it ldap search.sh -b "ou=people,dc=example,dc=local"
