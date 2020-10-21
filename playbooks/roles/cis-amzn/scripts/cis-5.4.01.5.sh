#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

egrep '^[^:]+:[^\!*]' /etc/shadow | awk -v epoch=$(date +%s) -F: '( $3*24*60*60>epoch ) { print "ALERT: Last password change in the future. User: " $1 " Epoch: " epoch " Change: " $3*24*60*60}' || true
