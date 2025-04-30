#!/bin/bash
service dbus restart
# service dovecot start
newaliases
# service postfix start
/startpulse.sh &
/usr/bin/mate-session > /dev/null 2>&1
