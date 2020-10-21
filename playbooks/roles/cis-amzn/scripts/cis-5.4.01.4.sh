#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

INACTIVE=$(useradd -D | grep INACTIVE | head --lines 1 --silent | tr --delete [:space:] | cut -d'=' -f2 | tr --delete [:space:])

if [ ${INACTIVE} -gt 30 ]; then
  echo "ALERT: default inactivity period is too long: ${INACTIVE}"
fi

if [ ${INACTIVE} -lt 1 ]; then
  echo "ALERT: default inactivity period is wrong: ${INACTIVE}"
fi

egrep ^[^:]+:[^\!*] /etc/shadow | awk -F: '($7>30 || $7<=0) { print "ALERT: " $1 " has wrong inactivity setting " $7 }' || true
