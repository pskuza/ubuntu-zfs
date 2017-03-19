#!/usr/bin/env bash
set -e
set -x

VERSION=1.8
FILE=go${VERSION}.linux-amd64.tar.gz

export GOPATH=${HOME}/go
PATH="${PATH}:${GOROOT}/bin:${GOPATH}/bin:/usr/local/go/bin"

if ! which go ; then
  [ ! -e ~/${FILE} ] && curl -o ~/${FILE} https://storage.googleapis.com/golang/${FILE}
  sudo tar -C /usr/local -xzf ~/${FILE}
fi
