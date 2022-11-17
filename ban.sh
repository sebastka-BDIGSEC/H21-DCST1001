#!/bin/sh
set -e      # Abort upon error
set -u      # Abort upon udefined variable
#set -x     # Print every command

readonly ban_db="$1"
readonly ip="$2"

touch "$ban_db"

# If ip is already banned, delete existing db entry
grep -qx "$ip" "$ban_db" && echo "/$ip/d\nwq" | ed -s "$ban_db" || true

# Ban
iptables -I INPUT -s "$ip" -j DROP

# Save ban in DB
echo "$ip,$(date +'%s')" >> "$ban_db"
