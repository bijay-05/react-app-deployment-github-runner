FROM node:hydrogen-alpine3.19 AS base

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn

FROM base AS linting

COPY . .

RUN yarn lint

FROM base AS build

COPY . .

COPY /src/config/prod.apiconfig.ts /app/src/config/apiconfig.ts

RUN yarn build

FROM nginx:mainline-alpine-slim AS production

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=build /app/dist .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
