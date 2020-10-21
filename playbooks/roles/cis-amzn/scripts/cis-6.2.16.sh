#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

cat /etc/passwd | grep --extended-regexp --invert-match "^$" | cut -f3 -d":" | sort -n | uniq -c | while read x ; do
  if [ -z "${x}" ]; then
    break;
  fi
  set - ${x}
  if [ ${1} -gt 1 ]; then
    users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs)
    echo "ALERT: duplicate UID (${2}): ${users}"
  fi
done

