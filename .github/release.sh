#!/bin/bash

set -xe # Show output on the logs

version="$1" # Get version tag
regex='v([0-9]+.[0-9]+.[0-9]+)-?([a-z]+)?.?([0-9]+)?'

if [[ $version =~ $regex ]]; then
  v="${BASH_REMATCH[1]}"
  channel="${BASH_REMATCH[2]}"
  channel_version="${BASH_REMATCH[3]}"
  
  tag="--tag ${DOCKER_IMAGE}:${version#v}"
  
  regex='([0-9]+).([0-9]+).([0-9]+)'
  if [[ $v =~ $regex ]]; then
    major=${BASH_REMATCH[1]}
    minor=${BASH_REMATCH[2]}
    patch=${BASH_REMATCH[3]}
    
    arr_version=( "${major}" "${major}.${minor}" "${major}.${minor}.${patch}" )
    if [[ -n "${channel}" ]]; then
      tag="--tag ${DOCKER_IMAGE}:${channel}"
      for i in "${arr_version[@]}"; do
        tag="${tag} --tag ${DOCKER_IMAGE}:${i}-${channel}"
      done
    else
      tag="--tag ${DOCKER_IMAGE}:latest --tag ${DOCKER_IMAGE}:stable"
      for i in "${arr_version[@]}"; do
        tag="${tag} --tag ${DOCKER_IMAGE}:${i}"
      done
    fi

    echo ${BASH_REMATCH[0]} # Entire match return 'v1.0.0-beta.1'
    echo ${BASH_REMATCH[1]} # group 1 return '1.0.12'
    echo ${BASH_REMATCH[2]} # group 2 return 'beta'
    echo ${BASH_REMATCH[3]} # group 3 return '10'

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
  else
    echo "Version '$v' didn't pass Regex '$regex'." 1>&2
    exit 1
  fi
else
  echo "Version '$version' didn't pass Regex '$regex'." 1>&2
  exit 1
fi
