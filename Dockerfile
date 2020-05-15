FROM mhart/alpine-node:12 AS builder

WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn build
RUN npm prune --production

FROM mhart/alpine-node:12

WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
# Running the app
CMD [ "yarn", "start" ]
