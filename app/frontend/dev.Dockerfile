FROM node:20-alpine3.19
ENV NODE_ENV development

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn

COPY . .

COPY /src/config/dev.apiconfig.ts /app/src/config/apiconfig.ts

EXPOSE 5173

CMD [ "yarn", "dev", "--host", "0.0.0.0" ]