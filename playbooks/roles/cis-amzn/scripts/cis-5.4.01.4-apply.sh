#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

egrep '^[^:]+:[^\!*]' /etc/shadow | awk -F: '($7>30 || $7<=0) { print $1}' | xargs -I{} --no-run-if-empty chage {} --inactive 30 || true
