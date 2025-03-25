FROM node:20-alpine3.19

RUN apk add --no-cache curl

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn

COPY . .

RUN if [ "$NODE_ENV" = "production" ]; \
    then cp prod.env .env; \
    else cp dev.env .env; \
    fi

EXPOSE 3000

RUN yarn build


CMD yarn migrate; \
    if [ ${NODE_ENV} = "production" ]; \
    then yarn start:production; \
    else yarn start:development; \
    fi
