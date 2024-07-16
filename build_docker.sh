#!/bin/bash

set -eu

# based on https://github.com/ollama/ollama/blob/main/scripts/build_docker.sh
export VERSION=${VERSION}
export GOFLAGS="'-ldflags=-w -s \"-X=github.com/ollama/ollama/version.Version=$VERSION\" \"-X=github.com/ollama/ollama/server.mode=release\"'"

TAG="dockerapp/ollama-general:$VERSION-${HOSTARCH}"

TARGETARCH=${HOSTARCH}

docker build \
    --progress=plain \
    --platform="linux/$TARGETARCH" \
    --build-arg=VERSION \
    --build-arg=GOFLAGS \
    -f ./src/Dockerfile \
    -t "${TAG}" \
    ./src
