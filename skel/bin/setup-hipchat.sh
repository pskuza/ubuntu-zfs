#!/usr/bin/env bash
set -e
set -x

[ ! -e /etc/apt/sources.list.d/atlassian-hipchat4.list ] && sudo tee /etc/apt/sources.list.d/atlassian-hipchat4.list <<EOF
deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main
EOF
wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -
sudo apt update

which hipchat4 || sudo apt install -y hipchat4
