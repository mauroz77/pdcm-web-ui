FROM node:lts-buster AS compile-image

VOLUME pdcm
WORKDIR /pdcm
COPY package.json yarn.lock ./
RUN df -h && yarn install

COPY . .
RUN yarn run build

FROM nginx:latest
RUN rm -rf /usr/share/nginx/html/*
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=compile-image /pdcm/build/ /usr/share/nginx/html
