#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

df --local --portability | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -o+w -printf 'ALERT: %M %p\n'

