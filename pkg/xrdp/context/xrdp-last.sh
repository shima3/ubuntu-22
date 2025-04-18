#!/bin/bash

log_file="/var/log/xrdp-sesman.log"
tz="$(date +%:z)"

# ログの解析用変数
declare -A map
declare -A login_time_map
declare -A session_map
# declare -A logout_time_map

# 日時フォーマット変換関数
convert_time() {
    local date_part="$1"
    local time_part="$2"
    local year="${date_part:0:4}"
    local month="${date_part:4:2}"
    local day="${date_part:6:2}"
    # echo "${year}-${month}-${day}T${time_part}${tz}"
    echo "${year}-${month}-${day}T${time_part}"
}

# ログをパース
while IFS= read -r line; do
    if [[ "$line" =~ ^\[([0-9]+)-([0-9:]+)\].*Starting\ session:\ session_pid\ ([0-9]+).*display[[:space:]]+([^,]+),.*ip[[:space:]]+([^[:space:]]+).*user\ name[[:space:]]+(.*) ]]; then
        timestamp="$(convert_time ${BASH_REMATCH[1]} ${BASH_REMATCH[2]})"
        session="${BASH_REMATCH[3]}"
        display="${BASH_REMATCH[4]}"
        ip="${BASH_REMATCH[5]}"
        user="${BASH_REMATCH[6]}"
        ip="${ip#::ffff:}"
        session_map["$ip"]="$session"
        ip="${ip%:*}"
        map["$session"]="$user\t$display\t$ip"
        login_time_map["$session"]="$timestamp"
    elif [[ "$line" =~ ^\[([0-9]+)-([0-9:]+)\].*reconnected\ session:.*username[[:space:]]+([^,]+),.*display[[:space:]]+([^,]+),.*session_pid[[:space:]]+([0-9]+),.*ip[[:space:]]+([^[:space:]]+) ]]; then
        user="${BASH_REMATCH[3]}"
        display="${BASH_REMATCH[4]}"
        session="${BASH_REMATCH[5]}"
        ip="${BASH_REMATCH[6]}"
        ip="${ip#::ffff:}"
        session_map["$ip"]="$session"
        ip="${ip%:*}"
        map["$session"]="$user\t$display\t$ip"
    elif [[ "$line" =~ ^\[([0-9]+)-([0-9:]+)\].*terminated\ session:.*username[[:space:]]+([^,]+),.*display[[:space:]]+([^,]+),.*session_pid[[:space:]]+([0-9]+),.*ip[[:space:]]+([^[:space:]]+) ]]; then
        timestamp="$(convert_time ${BASH_REMATCH[1]} ${BASH_REMATCH[2]})"
        user="${BASH_REMATCH[3]}"
        display="${BASH_REMATCH[4]}"
        session="${BASH_REMATCH[5]}"
        ip="${BASH_REMATCH[6]}"
        echo -e "${map[$session]}\t${login_time_map[$session]} - $timestamp"
        unset map["$session"]
        unset login_time_map["$session"]
    fi
done < "$log_file"

LC_ALL=C netstat --numeric --tcp | while read Proto RecvQ SendQ LocalAddress ForeignAddress State; do
    if [[ "$LocalAddress" =~ [0-9]+.[0-9]+.[0-9]+.[0-9]+:3389 ]]; then
        session="${session_map[$ForeignAddress]}"
        login_time="${login_time_map[$session]}"
        if [[ "$login_time" != "" ]]; then
            echo -e "${map[$session]}\t$login_time   still logged in"
            unset login_time_map["$session"]
        fi
        unset map["$session"]
    fi
done
    
for session in "${!map[@]}"; do
    echo -e "${map[$session]}\t${login_time_map[$session]}   gone - no logout"
done
