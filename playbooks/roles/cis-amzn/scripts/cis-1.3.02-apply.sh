#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail
#set -x

TMPD=$(mktemp --directory --tmpdir cis-1.3.2.XXXX);
trap 'rm -rf "${TMPD}"' EXIT INT TERM

echo 'before update'
crontab -l -u root 2>/dev/null >${TMPD}/crontab || truncate -s 0 ${TMPD}/crontab
cat ${TMPD}/crontab

if ! [ "$(grep -c aide ${TMPD}/crontab)" -ge 1 ]; then
  echo '0 5 * * * /usr/sbin/aide --check' >>${TMPD}/crontab
  cat ${TMPD}/crontab | crontab -u root -
fi

echo 'after update'
crontab -l -u root
