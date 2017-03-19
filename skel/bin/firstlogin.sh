#!/usr/bin/env bash
set -e
set -x

disable-automount.sh
backup-apt-cache.sh
for i in ~/bin/setup-* ; do
  ${i}
done
dtmpfs.sh
glances.sh
