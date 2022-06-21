var express = require('express');
var app = express();
var http = require('http').Server(app);

app.use(express.static('public'));
app.get('/', function (req, res) {
  res.sendFile(__dirname + '/index.html');
});

const { MongoClient } = require("mongodb");
const uri = "mongodb://localhost:27017/testdb";
const client = new MongoClient(uri);

// Mongodb Shell

// show dbs  // if database name = test
// use test
// show collections = show tables   // if table name = testTb
// db.testTb.find()
// db.testTb.findOne({date:"2021-01-31",site:"google.com"})
// db.stats() // show database detail 

async function run() {
  try {
    await client.connect();
    const pizzaDocument = {
      name: "lin",
      shape: "round",
      toppings: ["San Marzano tomatoes", "mozzarella di bufala cheese"],
    };
    const database = client.db("GaData");
    const collection = database.collection("test");

    // await collection.insertOne(pizzaDocument);

    const query = {
      date: "2021-01-31",
      site: "babyou"
    };
    const result = await collection.findOne(query)
    console.log(result)
    // const result = await collection.find()
    // console.log(result.pv[0])
  } finally {
    await client.close();
  }
}
run().catch(console.dir);


const host = '0.0.0.0';
const port = process.env.PORT || 3000;

http.listen(port, host, function () {
  console.log("Server started.......");
});