## remove
sudo apt-get remove nodejs
sudo apt-get purge nodejs
sudo apt-get autoremove
npm update -y

## pm2 
pm2 start yarn --time --name "NNTV" -- start
pm2 logs 0 --lines 150
pm2 restart 0 --time --watch
pm2 update
pm2 startup
pm2 save
pm2 show id //檢查當前 nodejs 版本
## eslint
npm i eslint -g
eslint --init

vscode 安裝套件 重開vscode

## update nodejs
nvm install 20
nvm use 20

## babel
yarn remove babel-cli babel-preset-env
yarn add @babel/core @babel/node @babel/preset-env --dev

cat>/var/www/html/.babelrc<<EOF
{
  "presets": [
    "@babel/preset-env"
  ]
}
EOF

cat>/var/www/html/package.json<<EOF
{
  "scripts": {
    "start": "nodemon --exec babel-node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "devDependencies": {
    "@babel/core": "^7.23.6",
    "@babel/node": "^7.22.19",
    "@babel/preset-env": "^7.23.6"
  },
  "name": "crawler",
  "version": "1.0.0",
  "main": "index.js",
  "license": "MIT",
  "dependencies": {
    "axios": "^1.6.2",
    "cheerio": "^1.0.0-rc.12"
  },
  "type": "module"
}

EOF

## init 
yarn add express body-parser cors dotenv