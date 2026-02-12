ref
https://socket.io/docs/v4/server-options/

POST TEST
curl -X POST http://127.0.0.1:4000/socket-to-client

# server
var io = require("socket.io")(http, {
  cors: {
    origin: "*",
  },
});

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

# client

```
  <script type="module">
    import {io} from "https://cdn.socket.io/4.4.1/socket.io.esm.min.js";
    const socket = io('ws://127.0.0.1:4000');
    // const socket = io('wss://dns');

    // 監聽 Server Event
    socket.on('earthquake event', function (msg) {
      let date = new Date();
      console.log(date);
      console.log(msg);
    })
    <script>
```
# nginx enable WebSockets
// 其他 webserver 設定方式
https://stackoverflow.com/questions/41381444/websocket-connection-failed-error-during-websocket-handshake-unexpected-respon
// 如果透過 nginx 走443 需要允許 WebSockets
location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $host;

    proxy_pass http://nodes;

    # enable WebSockets
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
}