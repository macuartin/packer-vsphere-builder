#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

cat /etc/passwd | grep --extended-regexp --invert-match "^$" | cut -f1 -d":" | sort -n | uniq -c | while read x ; do
  if [ -z "${x}" ]; then
    break;
  fi
  set - ${x}
  if [ ${1} -gt 1 ]; then
    uids=$(awk -F: '($1 == n) { print $3 }' n=$2 /etc/passwd | xargs)
    echo "ALERT: duplicate User Name (${2}): ${uids}"
  fi
done

