#!/usr/bin/env bash

set -o nounset
set -o noclobber
#set -o errexit
set -o pipefail

rpm --verify --all --nomtime --nosize --nomd5 --nolinkto
rc=${?}
echo "Exit code: ${rc}."
if [ ${rc} -eq 1 ]; then
  exit 0
else
  exit ${rc}
fi
