#!/usr/bin/env bash
set -e
set -x

OUTFILE="/etc/network/interfaces"
SOURCEDIR="/etc/network/interfaces.d"

[ -f ${OUTFILE} -a ! -f ${OUTFILE}.original ] && cp -a ${OUTFILE} ${OUTFILE}.original

cat >${OUTFILE} <<EOF
source ${SOURCEDIR}/*
EOF

if [ ! -f ${SOURCEDIR}/lo ]; then
  cat >${SOURCEDIR}/lo <<EOF
auto lo
iface lo inet loopback
EOF
fi

ACTIVE_NICS=$(ip link | grep '^[0-9]' | egrep -v '(^docker| lo:|NO-CARRIER)'  | cut -d' ' -f2 | cut -d: -f1)
for i in ${ACTIVE_NICS}; do
  if [ ! -f ${SOURCEDIR}/${i} ]; then
    cat >${SOURCEDIR}/${i} <<EOF
auto ${i}
iface ${i} inet dhcp
EOF
  fi
done

UNPLUG_NICS=$(ip link | grep '^[0-9]' | grep 'NO-CARRIER'  | cut -d' ' -f2 | cut -d: -f1)
for i in ${UNPLUG_NICS}; do
  if [ ! -f ${SOURCEDIR}/${i} ]; then
    cat >${SOURCEDIR}/${i} <<EOF
#auto ${i}
#iface ${i} inet dhcp
EOF
  fi
done
