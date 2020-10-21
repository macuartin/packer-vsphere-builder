#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

cat /etc/shadow | awk -F: '($2 == "" ) { print "ALERT: user " $1 " does not have a password."}'
