var express = require('express');
var app = express();
var http = require('http').Server(app);
const { exec } = require('child_process');
var bodyParser = require('body-parser');

app.use(bodyParser.json());
app.use(express.static('public')); //靜態檔案放置區

app.get('/', function(req, res) {
    res.send('Nodejs');
    // res.sendFile(__dirname + '/index.html');
    console.log("connect")
});
app.post('/uploads', function(req, res) {
    try {
        var gitkey = req.body.gitkey;
        console.log(gitkey)
        if (gitkey == "key") {
            console.log("Git Pull")
            exec(`git pull`, (err, stdout, stderr) => {
                if (err) {
                    // node couldn't execute the command
                    return;
                }

                // the *entire* stdout and stderr (buffered)
                console.log(`stdout: ${stdout}`);
                console.log(`stderr: ${stderr}`);
            });
        }
    } catch (err) {
        console.log(err);
    }
    res.send({ 'success': true, 'message': ' success' });
});

const host = '0.0.0.0';
const port = process.env.PORT || 3000;

http.listen(port, host, function() {
    console.log("Server started.......");
});