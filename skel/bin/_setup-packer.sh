#!/usr/bin/env bash
set -e
set -x

VERSION=0.12.3

which vagrant || sudo apt install -y vagrant

if [ ! -e /usr/bin/packer ]; then
  FILE=packer_${VERSION}_linux_amd64.zip
  mkdir -p ~/.apt-cache
  [ ! -e ~/.apt-cache/${FILE} ] && curl -o ~/.apt-cache/${FILE} -L https://releases.hashicorp.com/packer/${VERSION}/${FILE}
  unzip ~/.apt-cache/${FILE}
  sudo mv packer /usr/bin/packer
fi
