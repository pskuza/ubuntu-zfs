#!/usr/bin/env bash
set -e
set -x

sudo apt install -y libxcb-xtest0

if ! which zoom; then
    [ ! -e ~/zoom_amd64.deb ] && curl -o ~/zoom_amd64.deb -L https://zoom.us/client/latest/zoom_amd64.deb
    sudo dpkg -i ~/zoom_amd64.deb
fi
