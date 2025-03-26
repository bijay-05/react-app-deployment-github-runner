FROM node:21-bookworm-slim AS base

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn 

FROM base AS build

COPY . .

RUN yarn build

FROM node:21-bookworm-slim AS production

WORKDIR /app

COPY --from=build /app/src/db ./src/db
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

EXPOSE 80

CMD npx knex migrate:latest --knexfile src/db/knexfile.ts;\
    node dist/index.js