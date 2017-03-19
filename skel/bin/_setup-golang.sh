#!/usr/bin/env bash
set -e
set -x

VERSION=1.8

if ! which go ; then
  FILE=go${VERSION}.linux-amd64.tar.gz
  [ ! -e ~/${FILE} ] && curl -o ~/${FILE} -L https://storage.googleapis.com/golang/${FILE}
  sudo tar -C /usr/local -xzf ~/${FILE}
fi
