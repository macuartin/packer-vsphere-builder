#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

find /var/log -type f -perm -g+x -printf 'ALERT: file has group exec permissions %M %p\n'
find /var/log -type f -perm -g+w -printf 'ALERT: file has group write permissions %M %p\n'
find /var/log -type f -perm -o+r -printf 'ALERT: file has other read permissions %M %p\n'
find /var/log -type f -perm -o+w -printf 'ALERT: file has other write permissions %M %p\n'
find /var/log -type f -perm -o+x -printf 'ALERT: file has other exec permissions %M %p\n'
