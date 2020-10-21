#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail


cat /etc/passwd | grep --extended-regexp --invert-match "^$" | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
  echo "Processing ${user} (${dir}) ..."
  if [ ! -d "$dir" ]; then
    echo "ALERT: The home directory (${dir}) of user ${user} does not exist."
  else
    for file in ${dir}/.rhosts; do
      if [ ! -h "${file}" -a -f "${file}" ]; then
        echo "ALERT: .rhosts file in ${dir}"
      fi
    done
   fi
done
