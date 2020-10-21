#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

cat /etc/group | grep --extended-regexp --invert-match "^$" | cut -f3 -d":" | sort -n | uniq -c | while read x ; do
  if [ -z "${x}" ]; then
    break;
  fi
  set - ${x}
  if [ ${1} -gt 1 ]; then
    groups=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/group | xargs)
    echo "ALERT: duplicate GID (${2}): ${groups}"
  fi
done
