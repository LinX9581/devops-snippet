var app = require("express")();
var http = require("http").Server(app);
var io = require("socket.io")(http, {
  cors: {
    origin: "*",
  },
  // pingInterval: 35000
  pingTimeout: 5,
});
var cors = require("cors");
var port = process.env.PORT || 4005;

app.use(cors());
app.get("/", cors(), function (req, res) {
  res.sendFile(__dirname + "/index.html");
});

let i = 0;
let connector = 0;
io.on("connection", function (socket) {

  connector++;
  app.post("/socket-to-client", async function (req, res) {
    socket.broadcast.emit("earthquake event", "earthquake msg");
    res.send(
      JSON.stringify({
        connector: connector,
      })
    );
  });

  socket.on("disconnect", function () {
    connector--;
    console.log("left" + "\n" + "連線數: " + connector);
    clearInterval(connect_time)
    socket.broadcast.emit("user left");
  });
  console.log("連線數: " + connector);
});

http.listen(port, function () {
  console.log("listening on *:" + port);
});
