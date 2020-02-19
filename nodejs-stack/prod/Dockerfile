FROM node:stretch as build-env 

ENV WORKDIR="/usr/src/app"

WORKDIR $WORKDIR

ARG CODE_PATH

COPY ${CODE_PATH} /usr/src/app/

RUN npm install --only=dependencies

ARG TYPE_SCRIPT="0"

RUN [ "$TYPE_SCRIPT" = "1" ]; then npm run-script build; fi

FROM node:alpine
#gcr.io/distroless/nodejs

COPY --from=build-env /usr/src/app /app

WORKDIR /app

USER 1000

CMD ["npm run-script start"]