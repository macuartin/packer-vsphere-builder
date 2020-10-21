#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

OUT=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }' | tr -d [:blank:])
CNT=$(cat /etc/passwd | awk -F: '($3 == 0) { print $1 }' | tr -d [:blank:] | wc -l)

if [ ! "${CNT}" -eq "1" ]; then
  echo "ALERT: multiple or zero 0 UID acconts"
  exit 1
fi


if [ ! "${OUT}" == "root" ]; then
  echo "ALERT: no root account with 0 UID"
  exit 2
fi

exit 0

