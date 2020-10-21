#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
  if [ ! -d "${dir}" ]; then
    echo "ALERT: The home directory (${dir}) of user ${user} does not exist."
  else
    owner=$(stat -L -c "%U" "${dir}")
    if [ "${owner}" != "${user}" ]; then
      echo "ALERT: The home directory (${dir}) of user ${user} is owned by ${owner}."
    fi
  fi
done
