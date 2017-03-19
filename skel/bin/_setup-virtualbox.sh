#!/usr/bin/env bash
set -e
set -x

sudo apt install -y virtualbox-5.0
sudo apt install -y linux-headers-$(uname -r)

sudo /sbin/rcvboxdrv setup
