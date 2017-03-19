#!/usr/bin/env bash
set -e
set -x

#exit if no desktop installed
dpkg -l | grep ubuntu-desktop || exit

if ! which atom; then
  FILE=atom.deb
  mkdir -p ~/.apt-cache
  [ ! -e ~/.apt-cache/${FILE} ] && curl -o ~/.apt-cache/${FILE} -L https://atom.io/download/deb
  sudo dpkg -i ~/.apt-cache/${FILE}
fi

which shellcheck || sudo apt install -y shellcheck
which go || _setup-golang.sh || sudo apt install -y golang golang-go
which git || sudo apt install -y git

apm install linter
apm install linter-shellcheck

go get -u github.com/mvdan/sh/cmd/shfmt

apm install format-shell
