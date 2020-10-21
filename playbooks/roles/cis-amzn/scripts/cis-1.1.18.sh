#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) | while read x ; do
  echo "ALERT: word writable dir without sticky bit set (${x})"
done

