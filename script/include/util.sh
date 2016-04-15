#!/bin/bash

# Check the existence of a Docker network
#
# Arguments:
# - Name of the Docker network
network_exists() {
  local NETWORK=$1
  docker network inspect $NETWORK &>/dev/null

  local EXIT_CODE=$?
  return $EXIT_CODE
}

# Check the existence of a Docker container
#
# Arguments:
# - Name of the Docker container
container_exists() {
  local CONTAINER=$1
  docker inspect $CONTAINER &>/dev/null

  local EXIT_CODE=$?
  return $EXIT_CODE
}

# Check the existence of a Docker image
#
# Arguments:
# - Name of the Docker image
image_exists() {
  local IMAGE=$1
  docker inspect $IMAGE &>/dev/null

  local EXIT_CODE=$?
  return $EXIT_CODE
}
