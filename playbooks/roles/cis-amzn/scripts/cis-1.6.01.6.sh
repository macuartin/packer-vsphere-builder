#!/usr/bin/env bash

set -o nounset
set -o noclobber

ps -eZ | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ':' ' ' | awk '{ print $NF }'
