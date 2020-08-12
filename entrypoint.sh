#!/bin/bash

npm i -g netlify-cli

NETLIFY_AUTH_TOKEN=$1
NETLIFY_SITE_ID=$2
NETLIFY_DEPLOY_TO_PROD=$3
BUILD_DIRECTORY=$4
FUNCTIONS_DIRECTORY=$5
INSTALL_COMMAND=$6
BUILD_COMMAND=$7
BASE_DIRECTORY=$8

# Navigate to the base directory if one has been specified
if [[ $BASE_DIRECTORY ]]
then
	cd $BASE_DIRECTORY
fi

# Install dependencies
eval ${INSTALL_COMMAND:-"npm i"}

# Build project
eval ${BUILD_COMMAND:-"npm run build"}

# Export token to use with netlify's cli
export NETLIFY_SITE_ID=$NETLIFY_SITE_ID
export NETLIFY_AUTH_TOKEN=$NETLIFY_AUTH_TOKEN

# Deploy with netlify
if [[ $NETLIFY_DEPLOY_TO_PROD == "true" ]]
then
	netlify deploy --dir=$BUILD_DIRECTORY --functions=$FUNCTIONS_DIRECTORY --prod --message="$INPUT_NETLIFY_DEPLOY_MESSAGE"
else
	netlify deploy --dir=$BUILD_DIRECTORY --functions=$FUNCTIONS_DIRECTORY --message="$INPUT_NETLIFY_DEPLOY_MESSAGE"
fi

# Navigate back to the original directory if a base directory has been specified
if [[ $BASE_DIRECTORY ]]
then
	cd -
fi
