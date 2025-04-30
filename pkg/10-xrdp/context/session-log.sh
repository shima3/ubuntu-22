#!/bin/bash
# /usr/local/bin/session-log.sh
echo "$(date '+%F %T'): $PAM_USER $PAM_TYPE from $PAM_RHOST" >> /var/log/session.log
