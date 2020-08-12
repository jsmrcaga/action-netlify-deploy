# Netlify Deploy

This is a simple GitHub Action to deploy a static website to Netlify.

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
      - uses: jsmrcaga/action-netlify-deploy@v1.1.0
        with:
          NETLIFY_AUTH_TOKEN: ${{ secrets.MY_TOKEN_SECRET }}
          NETLIFY_DEPLOY_TO_PROD: true
```

### Inputs

As most GitHub actions, this action requires and uses some inputs, that you define in
your workflow file.

The inputs this action uses are:

|           Name           | Required |     Default     |                                                       Description                                                        |
| :----------------------: | :------: | :-------------: | :----------------------------------------------------------------------------------------------------------------------: |
|   `NETLIFY_AUTH_TOKEN`   |  `true`  |       N/A       | The token needed to deploy your site ([generate here](https://app.netlify.com/user/applications#personal-access-tokens)) |
|    `NETLIFY_SITE_ID`     |  `true`  |       N/A       |                    The site to where deploy your site (get it from the API ID on your Site Settings)                     |
| `NETLIFY_DEPLOY_MESSAGE` | `false`  |       ''        |                                                An optional deploy message                                                |
|    `build_directory`     | `false`  |    `'build'`    |                                         The directory where your files are built                                         |
|  `functions_directory`   | `false`  |       N/A       |                             The (optional) directory where your Netlify functions are stored                             |
|    `install_command`     | `false`  |     `npm i`     |                                      The (optional) command to install dependencies                                      |
|     `build_command`      | `false`  | `npm run build` |                                      The (optional) command to build static website                                      |
|     `base_directory`     | `false`  |       ''        |                                    The directory where the commands will be executed                                     |

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
      - uses: jsmrcaga/action-netlify-deploy@master
        with:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
          NETLIFY_DEPLOY_MESSAGE: 'Prod deploy v${{ github.ref }}'
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
      - uses: jsmrcaga/action-netlify-deploy@master
        with:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```
