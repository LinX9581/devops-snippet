const fs = require('fs');
const { google } = require('googleapis');
const OAuth2 = google.auth.OAuth2;
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const http = require('http').Server(app);
app.use(bodyParser.json());

let clientSecret = "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";
let clientId = "134222300814-hb34bisbcqq8j75d94ivek60d9k6bpqs.apps.googleusercontent.com";
let redirectUrl = "https://yt-test.linx.website/oauth";
let oauth2Client = new OAuth2(clientId, clientSecret, redirectUrl);
const scopes = [
    'https://www.googleapis.com/auth/youtube'
];
const token = fs.readFileSync('/root/.credentials/youtube-nodejs-quickstart.json', 'utf8')
oauth2Client.credentials = JSON.parse(token);

const youtube = google.youtube({
    version: 'v3',
    auth: oauth2Client
});

// Token 過期請重登
app.get('/', function(req, res) {
    const url = oauth2Client.generateAuthUrl({
        access_type: "offline",
        prompt: 'consent',
        scope: scopes,
    });
    res.redirect(url);
});

// 如果 /root/.credentials/youtube-nodejs-quickstart.json 沒拿到 Refresh Token
// 到這邊把Oauth授權移除掉 https://myaccount.google.com/permissions
// 再重新登入
app.get('/oauth', async function(req, res) {
    if (req.query.code) {
        const { tokens } = await oauth2Client.getToken(req.query.code)
        oauth2Client.setCredentials(tokens);
        storeToken(tokens)
        res.send('200');
    }
})

app.get('/list', function(req, res) {
    console.log('get list');
    youtube.playlistItems.list({
        auth: oauth2Client,
        part: 'id,snippet,contentDetails,status',
        playlistId: 'PLfhdpEaN9Xlk7vHCMebj79Lc7KQUq3CCX',
    }, function(err, response) {
        if (err) {
            console.log('The API returned an error: ' + err);
            return;
        }
        let listArray = []

        res.send(response.data);
    });
});

app.get('/update', async function(req, res) {
    console.log('get update');
    const response = await youtube.videos.update({
        part: 'id,snippet,status',
        auth: oauth2Client,
        requestBody: {
            id: "fzfRIwBJWQQ",
            snippet: {
                title: "public",
                description: "public",
                categoryId: "23"
            },
            status: {
                privacyStatus: 'public',
            },
        },
    });
    res.send(response.status);
});

app.post('/getyt', async function(req, res) {
    if (req.body.resource) {
        console.log(req.body.resource);
        let resource = req.body.resource
        let rest = req.body.rest
        let json = req.body.json
        json["auth"] = oauth2Client
        let response = await youtube[resource][rest](json);
        let listArray = []

        if (rest == 'update') {
            res.sendStatus(response.status);
        } else {
            res.send(response.data);
        }
    } else {
        res.send('No resource');
    }
});

function storeToken(tokens) {
    try {
        fs.mkdirSync('/root/.credentials/');
    } catch (err) {
        if (err.code != 'EEXIST') {
            throw err;
        }
    }
    fs.writeFile('/root/.credentials/youtube-nodejs-quickstart.json', JSON.stringify(tokens), (err) => {
        if (err) throw err;
        console.log('Token stored to ' + '/root/.credentials/youtube-nodejs-quickstart.json');
    });
}

const host = '0.0.0.0';
const port = process.env.PORT || 3300;

http.listen(port, host, function() {
    console.log("Server started.......");
});