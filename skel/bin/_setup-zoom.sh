#!/usr/bin/env bash
set -e
set -x

#exit if no desktop installed
dpkg -l | grep ubuntu-desktop || exit

sudo apt install -y libxcb-xtest0

if ! which zoom; then
  FILE=zoom_amd64.deb
  mkdir -p ~/.apt-cache
  [ ! -e ~/.apt-cache/${FILE} ] && curl -o ~/.apt-cache/${FILE} -L https://zoom.us/client/latest/${FILE}
  sudo dpkg -i ~/.apt-cache/${FILE}
fi
