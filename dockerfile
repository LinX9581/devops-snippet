FROM node:9.2.0

WORKDIR /app

COPY . /app

CMD node index.js