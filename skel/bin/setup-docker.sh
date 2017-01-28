#!/usr/bin/env bash
set -e
set -x

which docker || exit 0

DOCKER_IMAGES="
rancher/server
nicolargo/glances
"

for i in ${DOCKER_IMAGES}; do
  docker pull ${i}
done
