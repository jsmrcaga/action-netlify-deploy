# Netlify Deploy

This is a simple GitHub Action to deploy a static website to Netlify.

Forked from [jsmrcaga/action-netlify-deploy](https://github.com/jsmrcaga/action-netlify-deploy) with:

Remove features for simplicity and speed:

- no nvm install
- no install step
- no build step
- don't specify functions and build dir when calling `netlify deploy`

Added features:

- working-directory option, allowing for a .toml file in a monorepo.

## Usage

To use a GitHub action you can just reference it on your Workflow file
(for more info check [this article by Github](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/configuring-a-workflow))

```yml
name: 'My Workflow'

on:
  release:
    types: [published]

jobs:
  deploy:
    name: 'Deploy to Netlify'
    steps:
      - uses: loggedltd/action-netlify-deploy@v1.1.0
        with:
          NETLIFY_AUTH_TOKEN: ${{ secrets.MY_TOKEN_SECRET }}
          NETLIFY_DEPLOY_TO_PROD: true
```

### Inputs

As most GitHub actions, this action requires and uses some inputs, that you define in
your workflow file.

The inputs this action uses are:

| Name | Required | Default | Description |
|:----:|:--------:|:-------:|:-----------:|
| `NETLIFY_AUTH_TOKEN` | `true` | N/A | The token needed to deploy your site ([generate here](https://app.netlify.com/user/applications#personal-access-tokens))|
| `NETLIFY_SITE_ID` | `true` | N/A | The site to where deploy your site (get it from the API ID on your Site Settings) |
| `NETLIFY_DEPLOY_MESSAGE` | `false` | '' | An optional deploy message |
| `deploy_alias` | `false` | '' | (Optional) [Deployed site alias](https://cli.netlify.com/commands/deploy) |
| `working-directory` | `false` | '' | (Optional) Working directory |


### Outputs

The outputs for this action are:

`NETLIFY_OUTPUT`

Full output of the action

`NETLIFY_PREVIEW_URL`

The url of deployment preview.

`NETLIFY_LOGS_URL`

The url of the logs.

`NETLIFY_LIVE_URL`

The url of the live deployed site.


## Example

### Deploy to production on release

> You can setup repo secrets to use in your workflows

```yml
name: 'Netlify Deploy'

on:
  release:
    types: ['published']

jobs:
  deploy:
    name: 'Deploy'
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1
      - uses: loggedltd/action-netlify-deploy@master
        with:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
          NETLIFY_DEPLOY_MESSAGE: "Prod deploy v${{ github.ref }}"
          NETLIFY_DEPLOY_TO_PROD: true
```

### Preview Deploy on pull request

```yml
name: 'Netlify Preview Deploy'

on:
  pull_request:
    types: ['opened', 'edited', 'synchronize']

jobs:
  deploy:
    name: 'Deploy'
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1
      - uses: loggedltd/action-netlify-deploy@master
        with:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}

```

### Use branch name to deploy

Will deploy branches as `https://${branchName}--${siteName}.netlify.app`.

An action is used to extract the branch name to avoid fiddling with `refs/`. Finally, a commit status check is added, linking to the deployed site.

Only the default branch is built for simplicity. Use a similar workflow or standard Netlify integration for the production deployment.

```yml
name: 'Netlify Previews'

on:
  push:
    branches-ignore: 
      - master

jobs:
  deploy:
    name: 'Deploy'
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1

      # Sets the branch name as environment variable
      - uses: nelonoel/branch-name@v1.0.1
      - uses: loggedltd/action-netlify-deploy@master
        with:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
          deploy_alias: ${{ env.BRANCH_NAME }}
      
      # Creates a status check with link to preview
      - name: Status check
        uses: Sibz/github-status-action@v1.1.1
        with:
          authToken: ${{ secrets.GITHUB_TOKEN }}
          context: Netlify preview
          state: success
          target_url: https://${{ env.BRANCH_NAME }}--my-site.netlify.app
```

## Contributors

- [tpluscode](https://github.com/tpluscode)
- [wallies](https://github.com/wallies)
