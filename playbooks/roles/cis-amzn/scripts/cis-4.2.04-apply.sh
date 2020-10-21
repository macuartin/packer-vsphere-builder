#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail
#set -x

echo 'processing logs'

TMPD=$(mktemp --directory --tmpdir cis-4.2.4.XXXX);
trap 'rm -rf "${TMPD}"' EXIT INT TERM
echo 'root crontab before the update'
crontab -l -u root 2>/dev/null >${TMPD}/crontab || truncate -s 0 ${TMPD}/crontab
cat ${TMPD}/crontab

for FILE in /var/log; do
  echo "processing files ${FILE}"
  find ${FILE} -type f -exec chmod g-wx,o-rwx {} +
  grep -E -c "^.+find\s+${FILE}\s+.+type\s+d\s+.+chmod.+$" ${TMPD}/crontab || true
  if ! [ "$(grep -c -E ^.+find\\s+${FILE}\\s+.+type\\s+f\\s+.+chmod.+$ ${TMPD}/crontab)" -ge 1 ]; then
    echo "processing crontab for ${FILE}"
    echo "*/5 * * * * find ${FILE} -type f -exec chmod g-wx,o-rwx {} +" >>${TMPD}/crontab
    cat ${TMPD}/crontab | crontab -u root -
  else
    echo "skipping crontab for ${FILE}"
  fi
done;

for DIR in /var/log; do
  echo "processing dirs ${DIR}"
  find ${DIR} -type d -exec chmod -R g-wx,o-rwx {} +
  grep -E -c "^.+find\s+${DIR}\s+.+type\s+d\s+.+chmod.+$" ${TMPD}/crontab || true
  if ! [ "$(grep -c -E ^.+find\\s+${DIR}\\s+.+type\\s+d\\s+.+chmod.+$ ${TMPD}/crontab)" -ge 1 ]; then
    echo "processing crontab for ${DIR}"
    echo "*/5 * * * * find ${DIR} -type d -exec chmod -R g-wx,o-rwx {} +" >>${TMPD}/crontab
    cat ${TMPD}/crontab | crontab -u root -
  else
    echo "skipping crontab for ${DIR}"
  fi
done;

cat ${TMPD}/crontab | crontab -u root -
echo 'root crontab after the update'
crontab -l -u root
