FROM mhart/alpine-node:12 AS builder

RUN apk update && apk add curl bash

WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn build
RUN npm prune --production
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN /usr/local/bin/node-prune

FROM mhart/alpine-node:12

WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
CMD [ "yarn", "start" ]
