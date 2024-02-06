const session = require("express-session");
const redisStore = require("connect-redis")(session);
const redis = require("redis");
const express = require("express");
const app = express();
const http = require("http").Server(app);
app.use(express.static("public"));

app.use(
  session({
    secret: "secret-string",
    saveUninitialized: true,
    resave: false,
    store: new redisStore({ client: redis.createClient(6379, "127.0.0.1") }),
  })
);

app.get("/", function (req, res) {
  var session = req.session;
  session.count = session.count || 0;
  var n = session.count++;
  console.log("asd");
  res.send("hello, session id:" + session.id + " count:" + n);
});

const host = "0.0.0.0";
const port = process.env.PORT || 5000;

http.listen(port, host, function () {
  console.log("Server started.......");
});
