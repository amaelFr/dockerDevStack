FROM node:stretch

RUN npm install -g nodemon

ARG TYPE_SCRIPT="0"

RUN if [ "$TYPE_SCRIPT" = "1" ]; then npm install -g typescript ts-node ; fi

# COPY ./entrypoint.sh /usr/src/entrypoint.sh

USER 1000

ENV NODE_PATH=/usr/local/lib/node_modules

ARG BACKEND_WORKDIR=""

WORKDIR "/usr/src/app/${BACKEND_WORKDIR}"

#/usr/src/entrypoint.sh"
CMD ["npm", "run-script", "debug"]