#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

for user in `awk -F: '($3 < 500) {print $1 }' /etc/passwd` ; do
  if [ ${user} != "root" ]; then
    echo "Locking user: ${user}"
    usermod --lock ${user} 2>&1
    if [ ${user} != "sync" ] && [ ${user} != "shutdown" ] && [ ${user} != "halt" ]; then
      echo "Setting nologin shell: ${user}"
      usermod --shell /sbin/nologin ${user} 2>&1
    fi
  fi
done
