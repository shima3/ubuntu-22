#!/bin/bash
cd /home/shima
dayofweek="$1"
touch "$dayofweek.last"
xrdp_last.sh | while read -r user display ip login minus logout; do if [[ "$user" =~ [hj]20[0-9]?? && "$(LC_ALL=C date -d $login +%a)" == "$dayofweek" ]]; then echo -e "$user\t$login\t$ip"; fi; done | sort "$dayofweek.last" - | uniq > "/tmp/$dayofweek.last"
mv "/tmp/$dayofweek.last" .
chown shima.sudo "$dayofweek.last"
