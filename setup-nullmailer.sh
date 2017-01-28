#!/usr/bin/env bash
set -e
set -x

cd /root/ubuntu-zfs

. ./env.sh

OUTFILE="/etc/nullmailer/remotes"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
chmod 600 ${OUTFILE}
if [ -n "${GMAIL_USER}" -a -n "${GMAIL_PASSWORD}" ]; then
  cat >${OUTFILE} <<EOF
smtp.gmail.com smtp --port=587 --starttls --user=${GMAIL_USER} --pass=${GMAIL_PASSWORD}
EOF
fi

OUTFILE="/etc/nullmailer/adminaddr"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
chmod 644 ${OUTFILE}
if [ -n "${GMAIL_USER}" ]; then
  cat >${OUTFILE} <<EOF
${GMAIL_USER}
EOF
fi
