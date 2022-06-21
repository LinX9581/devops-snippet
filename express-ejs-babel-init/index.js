var express = require("express");
var app = require("express")();
var http = require("http").Server(app);
var port = process.env.PORT || 3000;

import expFunction from "./export-test";

app.use(express.static("public"));

//ejs 放置區
app.set("views", "views/");
app.set("view engine", "ejs");

app.get("/", function(req, res) {
    var a = expFunction(2) + " 這是import 進來的 function 值"
    res.render("index", {
        varName: a
            // name: loginUser || ''
    });
});


http.listen(port, function() {
    console.log("listening on *:" + port);
});