#!/bin/bash

echo "Building docker image..."
docker build . -q -t hw-install-tools
echo "Docker image ready"

HOME="$( cd ~ && pwd )"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ "$#" -eq 0 ]; then
    docker run -v $HOME/.ssh:/root/.ssh -v $DIR/data:/root/data --rm -it hw-install-tools /bin/bash
elif [ "$#" -eq 1 ] && [ "$1" = "autodeploy" ]; then
    docker run -v $HOME/.ssh:/root/.ssh -v $DIR/data:/root/data --rm -it hw-install-tools /root/data/deploy.sh
else
    docker run -v $HOME/.ssh:/root/.ssh -v $DIR/data:/root/data --rm -t hw-install-tools /bin/bash -c "$1"
fi