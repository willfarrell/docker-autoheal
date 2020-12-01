#!/usr/bin/env bash

IMAGE_NAME="willfarrell/autoheal"

usage() {
  echo "Usage: $0"
}

array_join() {
  local IFS="$1"
  shift
  echo "$*"
}

get_available_architectures() {
  local image="$1"
  local tag="${2:-latest}"

  docker buildx imagetools inspect --raw "${image}:${tag}" | \
    jq -r '.manifests[].platform | .os + "/" + .architecture + "/" + .variant' | \
    sed 's#/$##' | sort
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]
then
  set -ex

  cd "$(readlink -f "$(dirname "$0")")" || exit 9

  read -r base_image base_tag <<< \
    "$(sed -nr 's/^FROM\s+([^:]+):?((\w+).*)\s*$/\1 \3/p' Dockerfile | head -1)"
  # shellcheck disable=2207
  platforms=($(get_available_architectures "$base_image" "$base_tag"))

  PUSH_IMAGE=true
  BUILD_TYPE=manual

  if [[ "$TRAVIS" == "true" ]]
  then
    BUILD_TYPE=travis
  elif [[ "$GITHUB_ACTIONS" == "true" ]]
  then
    BUILD_TYPE=github
  fi

  docker buildx build \
    --platform "$(array_join "," "${platforms[@]}")" \
    --output "type=image,push=${PUSH_IMAGE}" \
    --no-cache \
    --label=build-type="$BUILD_TYPE" \
    --label=built-on="$HOSTNAME" \
    --tag "${IMAGE_NAME}:latest" \
    .
fi
