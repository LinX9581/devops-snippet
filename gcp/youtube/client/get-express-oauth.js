const fs = require('fs');
const bodyParser = require('body-parser');
const { google } = require('googleapis');
const OAuth2 = google.auth.OAuth2;
const express = require('express');
const app = express();
const http = require('http').Server(app);
app.use(express.static('public'));
app.use(bodyParser.json());

let clientSecret = "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";
let clientId = "134222300814-hb34bisbcqq8j75d94ivek60d9k6bpqs.apps.googleusercontent.com";
let redirectUrl = "https://yt-test.linx.services/oauth";
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

// 客製化欄位 寫一半
app.get('/youtube/v3/:resource/:rest', async function(req, res) {
    console.log(req.params);
    console.log(req.query);
    const response = await youtube.playlistItems.list({
        part: 'id,snippet,contentDetails',
        playlistId: 'PLmz6Vrm4YVOVT_RSnxZjE_Ev6bNu8TklE',
        maxResults: 50, // 預設為五筆資料，可以設定1~50
    });

    let listArray = []
    for (const iterator of response.data.items) {
        listArray.push(iterator.snippet)
    }
    res.send(listArray);
});

app.get('/playlist', async function(req, res) {
    const response = await youtube.playlistItems.list({
        part: 'id,snippet,contentDetails',
        playlistId: 'PLmz6Vrm4YVOVT_RSnxZjE_Ev6bNu8TklE',
        maxResults: 50, // 預設為五筆資料，可以設定1~50
    });
    // console.log(response.items);
    let listArray = []
    for (const iterator of response.data.items) {
        listArray.push(iterator.snippet)
    }
    res.send(listArray);
});

app.get('/videolist', async function(req, res) {
    const response = await youtube.search.list({
        part: [
            "snippet"
        ],
        forMine: true,
        maxResults: 25,
        type: [
                "video"
            ]
            // q="關鍵字 -排除關鍵字"
    });
    let listArray = []
    for (const iterator of response.data.items) {
        listArray.push(iterator.snippet)
    }
    res.send(listArray);
});

app.get('/update', async function(req, res) {
    const response = await youtube.videos.update({
        part: 'id,snippet,status',
        requestBody: {
            id: "2Dr3ud7jjS0",
            snippet: {
                title: "private",
                description: "private",
                categoryId: "23"
            },
            status: {
                privacyStatus: 'private',
            },
        },
    });
    console.log(response.status);
    res.send('update');
});

app.get('/upload', async function(req, res) {
    const nowStr = new Date().getTime().toString(36).substring(0, 4);
    const fileName = '/var/www/office.mp4'
    const fileSize = fs.statSync(fileName).size;
    const response = await youtube.videos.insert({
        part: 'id,snippet,status,contentDetails',
        notifySubscribers: false,
        requestBody: {
            snippet: {
                channelId: "UCP7vUHlfpivxiGRT4uOWi2g", // 上傳影片到哪個頻道
                title: `your-video-${nowStr}`, // 影片標題
                description: '測試上傳影片', // 影片描述
            },
            status: {
                privacyStatus: "private"
            },
        },
        media: {
            body: fs.createReadStream(fileName),
        },
    }, {
        // Use the `onUploadProgress` event from Axios to track the
        // number of bytes uploaded to this point.
        onUploadProgress: evt => {
            const progress = (evt.bytesRead / fileSize) * 100;
            console.log(`${Math.round(progress)}% complete`); // 顯示目前上傳進度 
        },
    });
    res.send('upload true');
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