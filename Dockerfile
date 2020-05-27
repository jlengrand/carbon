FROM node:12-alpine3.10 AS builder

RUN apk update && apk add curl bash

WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn build
RUN npm prune --production
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN /usr/local/bin/node-prune

FROM node:12-alpine3.10

WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/components ./components
COPY --from=builder /app/lib ./lib
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/pages ./pages
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/LICENSE ./LICENSE
COPY --from=builder /app/package.json ./package.json
EXPOSE 3000
USER 1001
CMD [ "yarn", "start" ]
