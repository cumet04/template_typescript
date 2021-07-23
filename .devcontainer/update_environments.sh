#!/bin/bash

set -eu

cd $(readlink -f $0 | xargs dirname)


MAJOR_VERSION=14
DEBIAN=buster
VERSION=$(
  curl -s "https://hub.docker.com/v2/repositories/library/node/tags/?name=$MAJOR_VERSION" | \
    jq -r '.results[].name' | grep "^[0-9]*\.[0-9]*\.[0-9]*-buster\$"
)
sed -i "1 s/.*/FROM node:$VERSION/" Dockerfile 


cd library-scripts/
TAG=$(curl -s https://api.github.com/repos/microsoft/vscode-dev-containers/releases/latest | jq -r '.tag_name')
curl -sOL https://raw.githubusercontent.com/microsoft/vscode-dev-containers/$TAG/script-library/common-debian.sh
cd ..

sed -i "s|blob/v[0-9\.]*/script-library|blob/$TAG/script-library|" Dockerfile
