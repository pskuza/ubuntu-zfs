#!/usr/bin/env bash
set -e
set -x

if [ -z "${1}" ]; then
  echo "USAGE: $0 NEWHOSTNAME" >&2
  exit 1
fi

OUTFILE="/etc/hostname"

hostname ${1}
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
cat >${OUTFILE} <<EOF
${1}
EOF

OUTFILE="/etc/hosts"

[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
if grep -q "127.0.1.1" ${OUTFILE}; then
  sed -i "s;127.0.1.1.*;127.0.1.1 ${1};" ${OUTFILE}
else
  cat >>${OUTFILE} <<EOF
127.0.1.1 ${1}
EOF
fi
