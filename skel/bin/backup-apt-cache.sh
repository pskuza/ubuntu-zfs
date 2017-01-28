#!/usr/bin/env bash
set -e
set -x

. ${HOME}/.env.sh

if [ -n "${RSYNC_CACHE_SERVER}" ]; then
  mkdir -p ${HOME}/.apt-cache/apt/archives
  rsync -virtP --exclude lock --exclude partial /var/lib/apt/lists/ ${HOME}/.apt-cache/lists/
  rsync -virtP --exclude lock --exclude partial /var/cache/apt/ ${HOME}/.apt-cache/apt/
  cd ${HOME}/.apt-cache/apt/archives
  dpkg -l | awk '$1~/ii/{print "apt download "$2}' | sh -ex
  cd -
  rsync -virtP --exclude lock --exclude partial ${HOME}/.apt-cache/ ${RSYNC_CACHE_SERVER}/
fi
