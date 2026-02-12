var app = require("express")();
var schedule = require("node-schedule")
var http = require("http").Server(app);
var io = require("socket.io")(http, {
    cors: {
        origin: "*",
    },
    // pingInterval: 35000
    pingTimeout: 5,
});
let connector = 0;
io.on("connection", function(socket) {
    connector++;
    schedule.scheduleJob('0 1 * * * *', async function() {
        console.log('reload page');
        socket.emit("reload", "reload");
    })

    socket.on("disconnect", function() {
        connector--;
        console.log("left");
        socket.broadcast.emit("user left");
    });
    console.log("連線數: " + connector);
});

app.get('/', function(req, res) {
    res.sendFile(__dirname + '/index.html');
    console.log("asd")
});

const host = '0.0.0.0';
const port = process.env.PORT || 4010;

http.listen(port, host, function() {
    console.log("Server started.......");
});