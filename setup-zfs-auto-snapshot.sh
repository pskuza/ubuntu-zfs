#!/usr/bin/env bash
set -e
set -x

git clone https://github.com/johnko/zfs-auto-snapshot.git
cd zfs-auto-snapshot
./install.sh
cd -
