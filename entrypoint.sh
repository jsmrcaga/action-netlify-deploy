#!/bin/bash

npm i -g netlify-cli

NETLIFY_AUTH_TOKEN=$1
NETLIFY_SITE_ID=$2
NETLIFY_DEPLOY_TO_PROD=$3
BUILD_DIRECTORY=$4
FUNCTIONS_DIRECTORY=$5

# Install dependencies
npm i

# Build project
npm run build

# Export token to use with netlify's cli
export NETLIFY_SITE_ID=$NETLIFY_SITE_ID
export NETLIFY_AUTH_TOKEN=$NETLIFY_AUTH_TOKEN

# Deploy with netlify
if [ -z $NETLIFY_DEPLOY_TO_PROD ]
then
	netlify deploy --dir=$BUILD_DIRECTORY --functions=$FUNCTIONS_DIRECTORY --message="$INPUT_NETLIFY_DEPLOY_MESSAGE"
else
	netlify deploy --dir=$BUILD_DIRECTORY --functions=$FUNCTIONS_DIRECTORY --prod --message="$INPUT_NETLIFY_DEPLOY_MESSAGE"
fi
