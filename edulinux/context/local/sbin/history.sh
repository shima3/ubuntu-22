#!/bin/bash
# Example$ history.sh -d 2025/03/15 /home/*/P3R7
case "$1" in
    '-p') pattern="$2"
          shift 2;;
    '-d') pattern='$2>="'$2'"'
          shift 2;;
esac
for file in "$@"; do
    user="$(stat -c '%U' $file 2> /dev/null)"
    home="$(getent passwd $user 2> /dev/null | cut -d: -f6)"
    # echo "home=$home"
    file="$home/.bash_history"
    history -cr $file
    # list=($(HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S ' history))
    mapfile -t list < <(HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S ' history)
    if [[ "$pattern" != "" ]]; then
        #         list=($(for item in "${list[@]}"; do echo "$item"; done | awk "$pattern"))
        # echo "pattern: $pattern"
        # printf '%s\n' "${list[@]}" | awk "$pattern"
        mapfile -t list < <(printf '%s\n' "${list[@]}" | awk "$pattern")
    fi
    echo "$user ${#list[@]}"
    # printf "%s\n" "${list[@]}"
    # IFS=$'\n'; echo "${list[@]}"
    for item in "${list[@]}"; do echo "$item"; done
done
exit 0
