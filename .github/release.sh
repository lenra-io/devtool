#!/bin/bash

set -xe # Show output on the logs

version="$1" # Get version tag
version="${version#v}" # remove the first `v` char

tag="--tag ${DOCKER_IMAGE}:$version"
if [[ "$version" != *"-beta."* ]]; then # If the version is a prerelease then don't publish on the short version code
  tag="${tag} --tag ${DOCKER_IMAGE}:${version%%.*} --tag ${DOCKER_IMAGE}:latest" # Remove all after the first dot (dot included)
else
  tag="${tag} --tag ${DOCKER_IMAGE}:${version%.*}" # Add a tag without beta number for generic beta image
fi

# build the docker image
docker buildx build \
  --output type=image,push=true \
  --platform "amd64,arm64,arm" \
  ${tag} \
  --build-arg CI=true \
  --build-arg GH_PERSONNAL_TOKEN="${GITHUB_TOKEN}" \
  --cache-from type=local,src=~/.docker-cache \
  --cache-to type=local,dest=~/.docker-cache \
  .
