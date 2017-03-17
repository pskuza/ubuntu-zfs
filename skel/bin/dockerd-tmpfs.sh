#!/bin/bash
set -e
set -x

TMPFS="/var/lib/docker"

sudo service docker stop

# mount tmpfs to speed up building
sudo mkdir -p "${TMPFS}"
mount | grep "${TMPFS}" || sudo mount -t tmpfs tmpfs "${TMPFS}"
mount | grep "${TMPFS}" || exit 1

sudo zfs set mountpoint=/var/lib/2docker system/docker
sudo rsync -vialP /var/lib/2docker/ /var/lib/docker/

sudo service docker start
