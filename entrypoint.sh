#!/bin/bash

set -e

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
if [[ -n $INSTALL_COMMAND ]]
then
	eval $INSTALL_COMMAND
elif [[ -f yarn.lock ]]
then
	yarn
else
	npm i
fi

# Build project
eval ${BUILD_COMMAND:-"npm run build"}

# Export token to use with netlify's cli
export NETLIFY_SITE_ID=$NETLIFY_SITE_ID
export NETLIFY_AUTH_TOKEN=$NETLIFY_AUTH_TOKEN

COMMAND="netlify deploy --dir=$BUILD_DIRECTORY --functions=$FUNCTIONS_DIRECTORY --message=\"$INPUT_NETLIFY_DEPLOY_MESSAGE\""

if [[ $NETLIFY_DEPLOY_TO_PROD == "true" ]]
then
	COMMAND+=" --prod"
elif [[ -n $DEPLOY_ALIAS ]]
then
	COMMAND+=" --alias $DEPLOY_ALIAS"
fi

# Deploy with netlify
eval $COMMAND
