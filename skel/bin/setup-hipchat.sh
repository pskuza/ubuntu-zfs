#!/usr/bin/env bash
set -e
set -x

SOURCE=/etc/apt/sources.list.d/atlassian-hipchat4.list

[ ! -e ${SOURCE} ] && sudo tee ${SOURCE} <<EOF
deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main
EOF

wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | sudo apt-key add -

sudo apt update

which hipchat4 || sudo apt install -y hipchat4
