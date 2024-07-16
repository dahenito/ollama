#!/bin/bash

set -eu

# based on https://github.com/ollama/ollama/blob/main/scripts/build_linux.sh
export VERSION=${VERSION}
export GOFLAGS="'-ldflags=-w -s \"-X=github.com/ollama/ollama/version.Version=$VERSION\" \"-X=github.com/ollama/ollama/server.mode=release\"'"

TARGETARCH=${HOSTARCH}
export AMDGPU_TARGETS=${AMDGPU_TARGETS:=""}
mkdir -p dist

docker build \
    --progress=plain \
    --platform="linux/$TARGETARCH" \
    --build-arg=GOFLAGS \
    --build-arg=CGO_CFLAGS \
    --build-arg=OLLAMA_CUSTOM_CPU_DEFS \
    --build-arg=AMDGPU_TARGETS \
    --target "build-$TARGETARCH" \
    -f ./src/Dockerfile \
    -t "builder:$TARGETARCH" \
    ./src

docker create --platform "linux/$TARGETARCH" --name "builder-$TARGETARCH" "builder:$TARGETARCH"
docker cp "builder-$TARGETARCH:/go/src/github.com/ollama/ollama/ollama" ./dist/ollama

if [ "$TARGETARCH" = "amd64" ]; then
    docker cp "builder-$TARGETARCH:/go/src/github.com/ollama/ollama/dist/deps/" ./dist/
fi

docker rm "builder-$TARGETARCH"
##
