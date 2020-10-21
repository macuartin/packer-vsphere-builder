#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

dmesg | grep NX | grep active
