#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

cat /etc/passwd | grep --extended-regexp --invert-match "^$" | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
  #echo "Processing ${user} (${dir}) ..."
  if [ ! -d "$dir" ]; then
    echo "ALERT: The home directory (${dir}) of user ${user} does not exist."
  else
    for file in ${dir}/.[A-Za-z0-9]*; do
      if [ ! -h "${file}" -a -f "${file}" ] || [ ! -h "${file}" -a -d "${file}" ]; then
        perm=`ls -l --directory ${file} | cut -f1 -d" "`
        #echo "Processing ${file} (${perm}) ..."
        if [ `echo ${perm} | cut -c6` != "-" ]; then
          echo "ALERT: Group Write set on ${file}"
        fi
        if [ `echo ${perm} | cut -c9` != "-" ]; then
          echo "ALERT: Other Write set on ${file}"
        fi
      fi
    done
  fi
done
