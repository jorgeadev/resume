#!/usr/bin/env bash

## create the ssh tunnel to fix docker for mac
if [[ "$(uname)" == "Darwin" ]]; then
    if [[ "$(docker ps -aq -f status=exited -f name='xhyve-container')" ]]; then
        # cleanup
        docker rm 'xhyve-container'
    fi
    if [[ ! "$(docker ps -q -f name=xhyve-container)" ]]; then
        # run your container
        docker run --name xhyve-container -id --rm --privileged --pid=host debian nsenter -t 1 -m -u -n -i \
        sh -c "apk add --no-cache socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:docker.for.mac.localhost:5000"
    fi
fi
