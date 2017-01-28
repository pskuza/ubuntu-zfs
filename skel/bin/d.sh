#!/usr/bin/env bash
set -e
set -x

# Make sure you are part of the docker group
# sudo usermod -aG docker myuser

PROCNAME="docker"

case "${1}" in
    i)
        set -- ${PROCNAME} images
    ;;
    p)
        set -- ${PROCNAME} ps -a
    ;;
    e)
        shift
        set -- ${PROCNAME} exec -it "${@}"
    ;;
    gc)
        # remove exited containers
        for i in $(docker ps -q -f status=exited); do
            docker rm ${i}
        done
        # remove untagged docker images
        for i in $(docker images -q -f dangling=true); do
            docker rmi ${i}
        done
        exit
    ;;
    *)
        set -- ${PROCNAME} "${@}"
    ;;
esac

"${@}"
