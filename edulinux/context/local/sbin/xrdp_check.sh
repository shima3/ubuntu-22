#!/bin/bash

LOGFILE="/var/log/xrdp.log"
declare -A conn_ips
declare -A conn_time
declare -A conn_count
declare -A tls_ips

while IFS= read -r line; do
    # 日時を抽出
    if [[ $line =~ ^\[([0-9]{8}-[0-9]{2}:[0-9]{2}:[0-9]{2})\] ]]; then
        timestamp="${BASH_REMATCH[1]}"
    fi

    # AF_INET6 connection の処理
    if [[ $line == *"AF_INET6 connection received from"* ]]; then
        ipport="${line##*from }"
        ip="${ipport%% *}"
        ip="${ip#::ffff:}"
        conn_ips["$ip"]=1
        conn_time["$ip"]="$timestamp"
        ((conn_count["$ip"]++))
    fi

    # TLS connection の処理
    if [[ $line == *"TLS connection established from"* ]]; then
        ipport="${line##*from }"
        ip="${ipport%% *}"
        ip="${ip#::ffff:}"
        tls_ips["$ip"]=1
    fi
done < "$LOGFILE"

# 一時配列に整形してソート
{
    for ip in "${!conn_ips[@]}"; do
        if [[ -z ${tls_ips["$ip"]} ]]; then
            echo "${conn_time[$ip]} $ip ${conn_count[$ip]}"
        fi
    done
} | sort | while read -r time ip count; do
    printf "%-19s %-15s %s\n" "$time" "$ip" "$count"
done
