#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

df --local --portability | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser -printf 'ALERT: File has no owner %M UID:%U %p\n'
