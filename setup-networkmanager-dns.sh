#!/usr/bin/env bash
set -e
set -x

OUTFILE="/etc/NetworkManager/NetworkManager.conf"
if [ -f ${OUTFILE} ]; then
  grep -q '^dns=dnsmasq' ${OUTFILE} && sed -i 's;^dns=dnsmasq;#dns=dnsmasq;' ${OUTFILE}
  #service network-manager restart
fi

