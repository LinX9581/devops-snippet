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
## eslint
npm i eslint -g
eslint --init

vscode 安裝套件 重開vscode

## babel
yarn remove babel-cli babel-preset-env
yarn add @babel/core @babel/node @babel/preset-env --dev

.babelrc
{
  "presets": [
    "@babel/preset-env"
  ]
}

  "scripts": {
    "start": "nodemon --exec babel-node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },