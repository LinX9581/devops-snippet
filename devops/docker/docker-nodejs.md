# nodejs
https://hub.docker.com/_/mysql
https://ithelp.ithome.com.tw/articles/10192519

# Base image
FROM node:latest
WORKDIR /usr/src/app
COPY package.json yarn.lock /usr/src/app/
RUN yarn install && yarn cache clean
COPY . /usr/src/app
EXPOSE 8080
CMD [ "yarn", "start" ]


docker build -t node-test . --no-cache
docker run  --name node-test -p 3000:3000 -it node-test


FROM node:15
WORKDIR /app       
COPY package.json .
# RUN npm install
ARG NODE_ENV
RUN if [ "$NODE_ENV" == "development" ]; \
    then npm install; \
    else npm install --only=production; \
    fi
COPY . ./
EXPOSE $PORT
CMD ["node","app.js"]