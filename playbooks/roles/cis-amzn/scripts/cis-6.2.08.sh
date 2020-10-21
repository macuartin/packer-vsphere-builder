#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

cat /etc/passwd | egrep -v '^(root|halt|sync|shutdown)' | awk -F: '($7 != "/sbin/nologin" && $7 != "/bin/false") { print $1 " " $6 }' | while read user dir; do
  if [ ! -d "${dir}" ]; then
    echo "ALERT: The home directory (${dir}) of user ${user} does not exist."
  else
    dirperm=`ls -ld ${dir} | cut -f1 -d" "`
    if [ `echo ${dirperm} | cut -c6` != "-" ]; then
      echo "ALERT: Group Write permission set on the home directory (${dir}) of user ${user}"
    fi
    if [ `echo ${dirperm} | cut -c8` != "-" ]; then
      echo "ALERT: Other Read permission set on the home directory (${dir}) of user ${user}"
    fi
    if [ `echo ${dirperm} | cut -c9` != "-" ]; then
      echo "ALERT: Other Write permission set on the home directory (${dir}) of user ${user}"
    fi
    if [ `echo ${dirperm} | cut -c10` != "-" ]; then
      echo "ALERT: Other Execute permission set on the home directory (${dir}) of user ${user}"
    fi
  fi
done

