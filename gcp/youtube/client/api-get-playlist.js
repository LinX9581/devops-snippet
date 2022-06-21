const axios = require('axios');
// axios.get('https://www.googleapis.com/youtube/v3/playlistItems', {
//     params: {
//         part: 'id,snippet,contentDetails', // 必填，把需要的資訊列出來
//         channelId: "PLfhdpEaN9XllS3xkaK_mJzIJrTNx2pMip",
//         maxResults: 50, // 預設為五筆資料，可以設定1~50
//         key: 'AIzaSyAgSiAdX_YQCEL9CMSiCwz4W1QPfy9qeGA'
//     }
// }).then(res => {
//     console.log(res.data)
//         // console.log(res.data.items.length);
// }).catch(e => console.log(e))
axios.get('https://www.googleapis.com/youtube/v3/videos', {
    params: {
        part: 'snippet,contentDetails,Cstatistics', // 必填，把需要的資訊列出來
        chart: 'mostPopular',
        regionCode: 'TW',
        // maxResults: 10, // 預設為五筆資料，可以設定1~50
        key: 'AIzaSyBeIGCh0EeucLX7xm4bjzXVKRuqueDRNxc'
    }
}).then(res => {
    console.log(res.data)
        // console.log(res.data.items.length);
}).catch(e => console.log(e))