#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

for group in $(cat /etc/passwd | grep --extended-regexp --invert-match "^$" | cut -s -d: -f4 | sort -u ); do
  grep --silent --perl-regexp "^.*?:[^:]*:${group}:" /etc/group || echo "ALERT: Group ${group} is referenced by /etc/passwd but does not exist in /etc/group"
done

