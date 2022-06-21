# 官方 nodejs sample
official            // server not working
official-client.js  // client not working

https://www.googleapis.com/youtube/v3/channels?part=statistics&id=UCCZS6YMggfiRV_U7NuiNNsg&key=AIzaSyCkbJ2X1g8GG1LztPXCBrHM10Z4WiWrbpw
## Express oauth
可以取得 token & refresh token 但還無法給client端使用
express-oauth
client              // not working

## 服務條款 隱私權條款
https://developers.google.com/youtube/terms/api-services-terms-of-service
https://developers.google.com/youtube/terms/developer-policies
https://stackoverflow.com/questions/49998874/youtube-iframe-api-is-not-showing-ads
https://stackoverflow.com/questions/19110271/video-ads-not-showing-in-youtube-html5-player
# Quota
https://developers.google.com/youtube/v3/determine_quota_cost

# Video REST API 官方文件
https://developers.google.com/youtube/v3/docs/videos/update?apix_params=%7B%22part%22%3A%5B%22id%2Csnippet%2Cstatus%22%5D%2C%22resource%22%3A%7B%22id%22%3A%222Dr3ud7jjS0%22%2C%22snippet%22%3A%7B%22title%22%3A%22test%22%2C%22description%22%3A%22test%22%2C%22categoryId%22%3A%2222%22%7D%2C%22status%22%3A%7B%22privacyStatus%22%3A%22private%22%7D%7D%7D

影片字幕
https://ithelp.ithome.com.tw/m/articles/10271204

免費影片素材
https://www.pexels.com/zh-tw/search/videos/%E8%BE%A6%E5%85%AC%E5%AE%A4/

nodejs oauth api 參考
https://hackmd.io/@c36ICNyhQE6-iTXKxoIocg/S1eYdtA1P

## get video list
const response = await youtube.playlistItems.list({
    part: 'id,snippet,contentDetails',
    playlistId: '影片清單ID',
    maxResults: 50, // 預設為五筆資料，可以設定1~50
});

## update video
// public private unlisted
const res = await youtube.videos.update(
    {
        part: 'id,snippet,status,contentDetails',
        notifySubscribers: false,
        requestBody: {
            id: "2Dr3ud7jjS0",
            snippet: {
                title: "private",
                description: "private",
                categoryId: "23"
            },
            status: {
                privacyStatus: "private" 
            },
        },
    },
);

## upload video
const nowStr = new Date().getTime().toString(36).substring(0, 4);
const fileName = '/var/www/office.mp4'
const fileSize = fs.statSync(fileName).size;
const response = await youtube.videos.insert(
    {
        part: 'id,snippet,status,contentDetails',
        notifySubscribers: false,
        requestBody: {
            snippet: {
                channelId, // 上傳影片到哪個頻道
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
    },
    {
        // Use the `onUploadProgress` event from Axios to track the
        // number of bytes uploaded to this point.
        onUploadProgress: evt => {
                const progress = (evt.bytesRead / fileSize) * 100;
                console.log(`${Math.round(progress)}% complete`); // 顯示目前上傳進度 
        },
    }
);

## 第一次授權才能拿到refresh token
超過第一次要先拔掉帳戶授權
https://myaccount.google.com/permissions

## 設定 access_type: "offline" 'consent', 
參考
https://stackoverflow.com/a/65108513/9404956
const url = oauth2Client.generateAuthUrl({
    access_type: "offline", # offline才拿的到token
    prompt: 'consent',      # 強制讓使用者允許YT權限
    scope: scopes,
});