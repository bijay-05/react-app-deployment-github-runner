FROM node:21-bookworm-slim AS base

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn

FROM base AS linting

COPY . .

RUN yarn lint

FROM base AS build

COPY . .

RUN yarn build

FROM node:21-bookworm-slim AS production

WORKDIR /app

COPY --from=build /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/server.js"]
