const express = require('express');
const router = express.Router();

const line = require('@line/bot-sdk');
const fs = require('fs');
const path = require('path');

// create LINE SDK client
const client = new line.Client({
    channelAccessToken: 'OxUCCy/7uZzZp47OXVJ+ECS+Epgc95ndFPtaUg7Obu9GuEgK31cLrCmJiRJWqfEyijb/ETmBmQFjNZc3JJsnMrJh4ogdMLL687S8B7gLdaxKsMo7qh/3BN4AjXmUvDfrvHNYJ+toab+GmTG4G7oBLwdB04t89/1O/w1cDnyilFU=',
    channelSecret: 'b298c64c1fcea600bdd60fdd3dfec31a'
});

router.post('/webhook', (req, res) => {
    Promise
        .all(req.body.events.map(handleEvent))
        .then((result) => res.json('result'))
        .catch((err) => {
            // console.error(err);
            res.status(500).end();
        });
});
function handleEvent(event) {
    if (event.replyToken && event.replyToken.match(/^(.)\1*$/)) {
        return console.log('Test hook recieved: ' + JSON.stringify(event.message));
    }
    console.log(`User ID: ${event.source.userId}`);
    let userId = event.source.userId;
    // console.log(event);
    if (event.message.text == 'test') {
        console.log('asdfasdf');
        client.replyMessage(event.replyToken,);
    }
    if(event.message.text == 'rp'){
        client.pushMessage(userId, { type: 'text', text: '132132' });
    }
    switch (event.type) {
        case 'message':
            const message = event.message;
            switch (message.type) {
                case 'image':
                    return handleImage(message);
                case 'file':
                    return handleImage(message);
                case 'video':
                    return handleImage(message);
                case 'audio':
                    return handleImage(message);
            }
    }
}

function handleImage(message) {
    let getContent;
    if (message.contentProvider.type === 'line') {
        const downloadPath = path.join(process.cwd(), 'public', 'downloaded', `${message.id}.txt`);

        downloadContent(message.id, downloadPath)
    } else if (message.contentProvider.type === 'external') {
        getContent = Promise.resolve(message.contentProvider);
    }
}

function downloadContent(messageId, downloadPath) {
    return client.getMessageContent(messageId)
        .then((stream) => new Promise((resolve, reject) => {
            const writable = fs.createWriteStream(downloadPath);
            stream.pipe(writable);
            stream.on('end', () => resolve(downloadPath));
            stream.on('error', reject);
        }));
}

module.exports = router;
