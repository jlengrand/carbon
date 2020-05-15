FROM node:12 AS builder

WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn build

FROM node:12

WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
# Running the app
CMD [ "yarn", "start" ]