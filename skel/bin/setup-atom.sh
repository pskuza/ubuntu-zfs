#!/usr/bin/env bash
set -e
set -x

if ! which atom; then
    [ ! -e ~/atom.deb ] && curl -o ~/atom.deb -L https://atom.io/download/deb
    sudo dpkg -i ~/atom.deb
fi

which shellcheck || sudo apt install -y shellcheck

which go || sudo apt install -y golang golang-go

which git || sudo apt install -y git

apm install linter

apm install linter-shellcheck

export GOPATH=${HOME}/go
PATH="${PATH}:${GOROOT}/bin:${GOPATH}/bin"

go get -u github.com/mvdan/sh/cmd/shfmt

apm install format-shell
