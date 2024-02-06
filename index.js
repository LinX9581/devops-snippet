import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';

const app = express();
const http = require('http').Server(app);

app.set("views", "views/");
app.set("view engine", "ejs");
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors());
app.use(express.static('public'));

const host = '0.0.0.0';
const port = process.env.PORT || 3005;

http.listen(port, host, function() {
    console.log("Server started on " + port);
});