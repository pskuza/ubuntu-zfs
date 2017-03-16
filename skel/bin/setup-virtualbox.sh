#!/usr/bin/env bash
set -e
set -x

sudo apt install -y linux-headers-$(uname -r)

sudo /sbin/rcvboxdrv setup
