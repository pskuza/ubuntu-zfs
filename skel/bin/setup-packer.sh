#!/usr/bin/env bash
set -e
set -x

which vagrant || sudo apt install -y vagrant

if [ ! -e /usr/bin/packer ]; then
  curl -L https://releases.hashicorp.com/packer/0.12.3/packer_0.12.3_linux_amd64.zip > ~/packer_0.12.3_linux_amd64.zip
  unzip ~/packer_0.12.3_linux_amd64.zip
  sudo mv packer /usr/bin/packer
fi
