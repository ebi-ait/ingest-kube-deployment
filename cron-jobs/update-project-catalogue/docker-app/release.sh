#!/usr/bin/env bash
source ./version.sh

docker build -t $DOCKER_REPO:$DOCKER_TAG .
docker push $DOCKER_REPO:$DOCKER_TAG