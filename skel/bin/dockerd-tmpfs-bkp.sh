#!/bin/bash
set -e
set -x

TMPFS="/var/lib/2docker"

mount | grep "${TMPFS}" || exit 1

sudo service docker stop

# backup tmpfs docker to disk
sudo rsync -vialP /var/lib/docker/ /var/lib/2docker/

sudo service docker start
