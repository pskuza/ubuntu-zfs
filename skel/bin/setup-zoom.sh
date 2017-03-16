#!/usr/bin/env bash
set -e
set -x

sudo apt install -y libxcb-xtest0

if ! which zoom; then
  FILE=zoom_amd64.deb
  [ ! -e ~/${FILE} ] && curl -o ~/${FILE} -L https://zoom.us/client/latest/${FILE}
  sudo dpkg -i ~/${FILE}
fi
