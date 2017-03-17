#!/usr/bin/env bash
set -e
set -x

docker run -d --restart=always -p 8080:8080 rancher/server

echo "visit http://localhost:8080/"
