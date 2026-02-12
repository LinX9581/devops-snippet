const fetch = require('node-fetch')
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var http = require('http').Server(app);
app.use(express.static('public'));
app.use(bodyParser.json());

// fetch('https://www.instagram.com/p/B-Y85rNp-OY/?__a=1')
// .then(res => res.json())
// .then(res => console.log(res));

app.get('/', async function(req, res) {
    // res.send('Hey Guys! we have a Gift for You!!!');
    console.log("asd")
        // let a = await fetch('https://www.instagram.com/explore/tags/taipeicafe/?__a=1')
    let igInfo = await fetch('https://www.instagram.com/sugar_togeter/?__a=1')
        .then(res => res.json())
        .then(res => {
            return res
        });
    console.log(igInfo);
    // console.log("使用者名稱: " + igInfo.graphql.user.biography);
    // console.log("追蹤數: " + igInfo.graphql.user.edge_followed_by);
    // 每一篇文章
    // console.log(igInfo.graphql.user.edge_owner_to_timeline_media);
    // 單篇文章
    // console.log(igInfo.graphql.user.edge_owner_to_timeline_media.edges[0].node);
    // res.send(igInfo.graphql.user.edge_owner_to_timeline_media.edges)
    res.send(igInfo)
});

const host = '0.0.0.0';
const port = process.env.PORT || 3000;

http.listen(port, host, function() {
    console.log("Server started.......");
});