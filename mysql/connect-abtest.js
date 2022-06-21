const query = require('./mysql');
const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const http = require('http').Server(app);
app.use(express.static('public'));
app.use(bodyParser.json());

app.get('/', function(req, res) {
    res.sendFile(__dirname + '/index.html');
    console.log("asd")
});
app.post('/uploads', async function(req, res) {
    console.log(req.body)

    let checkDbchannel = await query('select * from wp_db.channel LIMIT 10')
    console.log(checkDbchannel);
    res.send(JSON.stringify({
        "reinsert": "success"
    }));
})
const host = '0.0.0.0';
const port = process.env.PORT || 5000;

http.listen(port, host, function() {
    console.log("Server started.......");
});