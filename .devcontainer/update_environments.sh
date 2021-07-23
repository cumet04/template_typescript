#!/bin/bash

set -eu

cd $(readlink -f $0 | xargs dirname)

MAJOR_VERSION=14
DEBIAN=buster

# update Dockerfile's base image version
VERSION=$(
  curl -s "https://hub.docker.com/v2/repositories/library/node/tags/?name=$MAJOR_VERSION" | \
    jq -r '.results[].name' | grep "^[0-9]*\.[0-9]*\.[0-9]*-buster\$"
)
sed -i "1 s/.*/FROM node:$VERSION/" Dockerfile 

# update @types/node version
replaced=$(cat ../package.json | jq ".devDependencies.\"@types/node\"|=\"$(echo $VERSION | cut -d'-' -f1)\"")
echo "$replaced" > ../package.json

# update library-scripts
TAG=$(curl -s https://api.github.com/repos/microsoft/vscode-dev-containers/releases/latest | jq -r '.tag_name')
curl -sL -o library-scripts/common-debian.sh https://raw.githubusercontent.com/microsoft/vscode-dev-containers/$TAG/script-library/common-debian.sh
sed -i "s|blob/v[0-9\.]*/script-library|blob/$TAG/script-library|" Dockerfile
