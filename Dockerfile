FROM node:current-stretch-slim

ADD entrypoint.sh /entrypoint.sh
ADD action.yml /action.yml

ENTRYPOINT ["/entrypoint.sh"]
