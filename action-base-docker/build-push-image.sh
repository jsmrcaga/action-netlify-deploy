#!/bin/bash

cd "$(dirname "$0")"

version=${1:-0.1.0}

echo "Building crisperit/action-netlify-deploy:${version} and marking it as latest"
docker build -t "crisperit/action-netlify-deploy:${version}" -t "crisperit/action-netlify-deploy:latest" .

echo "Pushing newest crisperit/action-netlify-deploy"
docker push crisperit/action-netlify-deploy:${version}
docker push crisperit/action-netlify-deploy:latest