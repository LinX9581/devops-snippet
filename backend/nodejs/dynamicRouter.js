var express = require('express');
var app = express();
var http = require('http').Server(app);
const fs = require('fs');

app.set("views", "views/");
app.set("view engine", "ejs");

app.use(express.static('public'));
app.use('/test2', express.static('public'));

app.get('/test2', function(req, res) {
    // res.send('Hey Guys! we have a Gift for You!!!');
    let title = "dsfsdfsdfdsfs"
    res.render('index', {
        title
    });
});
app.get('/test2/test', function(req, res) {
    // res.send('Hey Guys! we have a Gift for You!!!');
    let title = "dsfsdfsdfdsfs"
    res.render('index', {
        title
    });
});
app.get('/test/:name/', function(req, res) {
    let fileName = req.params.name;
    console.log(req.params.name);
    let title = "dsfsdfsdfdsfs"

    fs.copyFile("./views/index.ejs", "./views/" + fileName + ".ejs", (err) => {
        if (err) {
            console.log("Error Found:", err);
        } else {
            res.render(fileName, {
                title
            });
        }
    });
    res.sendFile(__dirname + '/index.html');
});
app.post('/date', function(req, res) {
    console.log("asdasd")
    res.redirect(307, '/login')
})
const host = '0.0.0.0';
const port = process.env.PORT || 5000;

http.listen(port, host, function() {
    console.log("Server started.......");
});