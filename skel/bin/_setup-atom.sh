#!/usr/bin/env bash
set -e
set -x

if ! which atom; then
  FILE=atom.deb
  [ ! -e ~/${FILE} ] && curl -o ~/${FILE} -L https://atom.io/download/deb
  sudo dpkg -i ~/${FILE}
fi

which shellcheck || sudo apt install -y shellcheck
which go || _setup-golang.sh || sudo apt install -y golang golang-go
which git || sudo apt install -y git

apm install linter
apm install linter-shellcheck

export GOPATH=${HOME}/go
PATH="${PATH}:${GOROOT}/bin:${GOPATH}/bin:/usr/local/go/bin"
go get -u github.com/mvdan/sh/cmd/shfmt

apm install format-shell
