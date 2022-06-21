const lineRouter = require('./line');
const line = require('@line/bot-sdk');
const express = require('express');
const app = express();

var http = require('http').Server(app);
var port = process.env.PORT || 5000;
app.use(express.static('public'));
app.use('/', line.middleware({
    channelAccessToken: 'OxUCCy/7uZzZp47OXVJ+ECS+Epgc95ndFPtaUg7Obu9GuEgK31cLrCmJiRJWqfEyijb/ETmBmQFjNZc3JJsnMrJh4ogdMLL687S8B7gLdaxKsMo7qh/3BN4AjXmUvDfrvHNYJ+toab+GmTG4G7oBLwdB04t89/1O/w1cDnyilFU=',
    channelSecret: 'b298c64c1fcea600bdd60fdd3dfec31a'
  }), lineRouter);
  

http.listen(port, function () {
    console.log('My Line bot App running on 5000');
});

// 參考
// https://medium.com/@s1k2y37st/linebot%E7%B3%BB%E5%88%97-%E4%B8%80-%E8%81%8A%E5%A4%A9bot%E7%9A%84helloworld-echo-bot-ec93eb6c734e
// 官方 Gitgub文件
// https://github.com/boybundit/linebot
//https://github.com/clarencetw/line-bot/blob/bf6482e9f0fc84416f0ea0e9790535a8eaf69ffb/routes/line.js