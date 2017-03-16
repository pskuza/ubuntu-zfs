#!/usr/bin/env bash
set -e
set -x

which go || sudo apt install -y golang golang-go
which git || sudo apt install -y git

if [ ! -e /usr/bin/dapper ]; then
  export GOPATH=${HOME}/go
  PATH="${PATH}:${GOROOT}/bin:${GOPATH}/bin"

  go get github.com/rancher/dapper
  sudo mv ~/go/bin/dapper /usr/bin/dapper
fi
