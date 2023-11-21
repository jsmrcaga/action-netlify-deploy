#!/bin/bash

set -e

# Run install command
if [[ -n "${INSTALL_COMMAND}" ]]
then
  ${INSTALL_COMMAND}
elif [[ -f yarn.lock ]]
then
  yarn
else
  npm i
fi

# Run build command
if [[ -n "${BUILD_COMMAND}" ]]
then
  ${BUILD_COMMAND}
else
  npm run build
fi

# Deploy to Netlify
export NETLIFY_SITE_ID="${NETLIFY_SITE_ID}"
export NETLIFY_AUTH_TOKEN="${NETLIFY_AUTH_TOKEN}"

# command based on https://cli.netlify.com/commands/deploy
COMMAND="netlify deploy --dir=${BUILD_DIRECTORY} --functions=${FUNCTIONS_DIRECTORY} --message=\"${NETLIFY_DEPLOY_MESSAGE}\""

if [[ "${NETLIFY_DEPLOY_TO_PROD}" == "true" ]]
then
  COMMAND+=" --prod"
elif [[ -n "${DEPLOY_ALIAS}" ]]
then
  COMMAND+=" --alias ${DEPLOY_ALIAS}"
fi

if [[ -n "${MONOREPO_PACKAGE}" ]]
then
  COMMAND+=" --filter ${MONOREPO_PACKAGE}"
fi

if [[ -n "${DEBUG}" ]]
then
  COMMAND+=" --debug "
fi

if [[ -n "${COMMAND_EXTRA_FLAGS}" ]]
then
  COMMAND+=" ${COMMAND_EXTRA_FLAGS} "
fi

OUTPUT=$(sh -c "$COMMAND")

# Set outputs
NETLIFY_OUTPUT=$(echo "$OUTPUT")
NETLIFY_PREVIEW_URL=$(echo "$OUTPUT" | grep -Eo '(http|https)://[a-zA-Z0-9./?=_-]*(--)[a-zA-Z0-9./?=_-]*') #Unique key: --
NETLIFY_LOGS_URL=$(echo "$OUTPUT" | grep -Eo '(http|https)://app.netlify.com/[a-zA-Z0-9./?=_-]*') #Unique key: app.netlify.com
NETLIFY_LIVE_URL=$(echo "$OUTPUT" | grep -Eo '(http|https)://[a-zA-Z0-9./?=_-]*' | grep -Eov "netlify.com") #Unique key: don't containr -- and app.netlify.com

echo "NETLIFY_OUTPUT<<EOF" >> $GITHUB_ENV
echo "$NETLIFY_OUTPUT" >> $GITHUB_ENV
echo "EOF" >> $GITHUB_ENV

echo "NETLIFY_PREVIEW_URL<<EOF" >> $GITHUB_ENV
echo "$NETLIFY_PREVIEW_URL" >> $GITHUB_ENV
echo "EOF" >> $GITHUB_ENV

echo "NETLIFY_LOGS_URL<<EOF" >> $GITHUB_ENV
echo "$NETLIFY_LOGS_URL" >> $GITHUB_ENV
echo "EOF" >> $GITHUB_ENV

echo "NETLIFY_LIVE_URL<<EOF" >> $GITHUB_ENV
echo "$NETLIFY_LIVE_URL" >> $GITHUB_ENV
echo "EOF" >> $GITHUB_ENV
