#!/usr/bin/env bash
set -e
set -x

_disable-automount.sh
_backup-apt-cache.sh
_setup-sudoers.sh
_setup-golang.sh
for i in ~/bin/_setup-* ; do
  ${i}
done
dtmpfs.sh
glances.sh
