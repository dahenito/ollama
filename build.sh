#!/bin/bash

set -euo pipefail

function get_docker() {
    echo "Docker is required. Please install docker and try again."
    echo "https://docs.docker.com/get-docker/"
    exit 1
}

function check_docker() {
	command -v docker &>/dev/null || get_docker
}

#
check_docker

#
. source.env

echo "platform: $HOSTOS/$HOSTARCH"
case "$HOSTOS/$HOSTARCH" in
    linux/amd64|linux/arm64)
        ./build_linux.sh
        ;;
    darwin/amd64|darwin/arm64)
        # TODO 
        # ./build_darwin.sh
        ./build_docker.sh
        ;;
    *)
        ./build_docker.sh
        ;;
esac

echo "Built ollama version $VERSION"
