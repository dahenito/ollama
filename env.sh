#!/bin/bash

VARS=(
VERSION
DOCKER_APP_BASE
DOCKER_APP_PATH
HOSTOS
HOSTARCH
USERHOME
USERNAME
)

for v in "${VARS[@]}"; do
  echo "export $v=${!v}"
done