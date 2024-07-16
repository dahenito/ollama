#!/bin/bash

set -euo pipefail

#
DIR="$(dirname "$(readlink -f "$0")")"
cd "$DIR"

. source.env

##
TAG="dockerapp/ollama-general:$VERSION-${HOSTARCH}"

function start_general() {
	docker run -it --rm \
		"$TAG" \
		serve
}

function start_linux() {
	./dist/ollama serve
}

function start_darwin() {
	# ./dist/ollama serve
    start_general
}

echo "platform: $HOSTOS/$HOSTARCH"
case "$HOSTOS/$HOSTARCH" in
    linux/amd64|linux/arm64)
        start_linux
        ;;
    darwin/amd64|darwin/arm64)
        start_darwin
        ;;
    *)
        start_general
        ;;
esac
