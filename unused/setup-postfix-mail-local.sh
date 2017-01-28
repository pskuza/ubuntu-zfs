#!/usr/bin/env bash
set -e
set -x

cd /root/ubuntu-zfs

. ./env.sh

: ${NEWHOSTNAME=unassigned-hostname}

OUTFILE="/etc/postfix/main.cf"
[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original
install -m 644 main.cf.local ${OUTFILE}
sed -i "s;unassigned-hostname;${NEWHOSTNAME};" ${OUTFILE}

newaliases
