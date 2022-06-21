var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var http = require('http').Server(app);
app.use(express.static('public'));
app.use(bodyParser.json());
// app.use(bodyParser.urlencoded({ extended: false }));
// app.use(cors());
app.get('/', function(req, res) {
    // res.send('Hey Guys! we have a Gift for You!!!');
    res.sendFile(__dirname + '/index.html');
    console.log("asd")
});
app.post('/uploads', function(req, res) {
    console.log(req.body)
        // res.redirect(307, '/login')
    res.send(JSON.stringify({
        "reinsert": "success"
    }));
})
const host = '0.0.0.0';
const port = process.env.PORT || 80;

http.listen(port, host, function() {
    console.log("Server started.......");
});