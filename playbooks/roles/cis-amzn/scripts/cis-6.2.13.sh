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
    for file in ${dir}/.netrc; do
      if [ ! -h "${file}" -a -f "${file}" ]; then
        prem=`ls -ld ${file} | cut -f1 -d" "`
        if [ `echo ${prem} | cut -c5` != "-" ]; then
          echo "ALERT: Group Read set on ${file}"
        fi
        if [ `echo $prem | cut -c6` != "-" ]; then
          echo "ALERT: Group Write set on ${file}"
        fi
        if [ `echo $prem | cut -c7` != "-" ]; then
          echo "ALERT: Group Execute set on ${file}"
        fi
        if [ `echo $prem | cut -c8` != "-" ]; then
          echo "ALERT: Other Read set on ${file}"
        fi
        if [ `echo $prem | cut -c9` != "-" ]; then
          echo "ALERT: Other Write set on ${file}"
        fi
        if [ `echo $prem | cut -c10` != "-" ]; then
          echo "ALERT: Other Execute set on ${file}"
        fi
      fi
    done
  fi
done
