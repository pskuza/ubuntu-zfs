#!/usr/bin/env bash
set -e
set -x

. ${HOME}/.env.sh

if [ -n "${RSYNC_CACHE_SERVER}" ]; then
  mkdir -p /home/${NEWUSER}/.apt-cache/apt/archives
  rsync -virtP --exclude lock --exclude partial /var/lib/apt/lists/ /home/${NEWUSER}/.apt-cache/lists/
  rsync -virtP --exclude lock --exclude partial /var/cache/apt/ /home/${NEWUSER}/.apt-cache/apt/
  chown -R ${NEWUSER} /home/${NEWUSER}/.apt-cache
  cd /home/${NEWUSER}/.apt-cache/apt/archives
  dpkg -l | awk '$1~/ii/{print "sudo -u ${NEWUSER} apt download "$2}' | sh -ex
  cd -
  rsync -virtP --exclude lock --exclude partial /home/${NEWUSER}/.apt-cache/ ${RSYNC_CACHE_SERVER}/
fi
