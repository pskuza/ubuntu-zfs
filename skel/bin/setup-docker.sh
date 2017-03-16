#!/usr/bin/env bash
set -e
set -x

which docker || sudo apt install -y docker.io

DOCKER_IMAGES="
rancher/server
nicolargo/glances
"

for i in ${DOCKER_IMAGES}; do
  docker pull ${i}
done
