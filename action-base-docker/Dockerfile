FROM williamjackson/netlify-cli

USER root

RUN apk add --update curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | /bin/bash -l
RUN [ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"

