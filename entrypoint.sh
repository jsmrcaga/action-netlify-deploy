#!/bin/bash

npm i -g netlify-cli

NETLIFY_AUTH_TOKEN=$1
NETLIFY_SITE_ID=$2
NETLIFY_DEPLOY_TO_PROD=$3
BUILD_DIRECTORY=$4
FUNCTIONS_DIRECTORY=$5
INSTALL_COMMAND=$6
BUILD_COMMAND=$7
DEPLOY_ALIAS=$8

# Install dependencies
eval ${INSTALL_COMMAND:-"npm i"}

# Build project
eval ${BUILD_COMMAND:-"npm run build"}

# Export token to use with netlify's cli
export NETLIFY_SITE_ID=$NETLIFY_SITE_ID
export NETLIFY_AUTH_TOKEN=$NETLIFY_AUTH_TOKEN

COMMAND="netlify deploy --dir=$BUILD_DIRECTORY --functions=$FUNCTIONS_DIRECTORY --message=\"$INPUT_NETLIFY_DEPLOY_MESSAGE\""

if [[ $NETLIFY_DEPLOY_TO_PROD == "true" ]]
then
	COMMAND+=" --prod"
fi

if [[ -n $DEPLOY_ALIAS ]]
then
	COMMAND+=" --alias $COMMAND"
fi

# Deploy with netlify
eval $COMMAND
