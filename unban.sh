#!/bin/sh
set -e      # Abort upon error
set -u      # Abort upon udefined variable
#set -x     # Print every command

readonly ban_db="$1"
touch "$ban_db"

readonly now="$(date +'%s')"
readonly file_old_content="$(cat "$ban_db")"

# Loop through file content and remove/unban old entries
IFS=','
echo "$file_old_content" | while read ip timestamp; do
    if [ $now -le $(echo "$timestamp + 10*60" | bc) ]; then
        # Remove existing rules
        iptables -D INPUT -s "$ip" -j REJECT

        # Remove from ban db
        echo "/$ip/d\nwq" | ed -s "$ban_db" || true
    fi
done
