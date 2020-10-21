#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

echo "Fetching UID_MIN ..."
cat /etc/login.defs | grep UID_MIN

cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
  if [ ! -d "$dir" ]; then
    echo "ALERT: The home directory (${dir}) of user ${user} does not exist."
  fi
done

