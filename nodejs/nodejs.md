## remove


sudo apt-get remove nodejs
sudo apt-get purge nodejs
sudo apt-get autoremove
npm update -y

## eslint
npm i eslint -g
eslint --init

vscode 安裝套件 重開vscode

---
alert(window.navigator.userAgent)
navigator
    .userAgentData.getHighEntropyValues(
        ["architecture", "model", "platform", "platformVersion",
            "uaFullVersion"
        ])
    .then(ua => {
        console.log(ua)
    });
---
https://user-agent-client-hints.glitch.me/javascript.html

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