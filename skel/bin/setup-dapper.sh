#!/usr/bin/env bash
set -e
set -x

if [ ! -e /usr/bin/dapper ]; then
  export GOPATH=${HOME}/go
  PATH="${PATH}:${GOROOT}/bin:${GOPATH}/bin"

  go get github.com/rancher/dapper
  sudo mv ~/go/bin/dapper /usr/bin/dapper
fi
