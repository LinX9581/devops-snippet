import { createReadStream } from 'fs';
import express from 'express';
var fs = require('fs');
const app = express();
var readStream = createReadStream('./fs/dump.txt');

// app.get('/', (req, res) => {
//     readStream.on('data', (data) => {
//         res.write(data);
//     });
//     readStream.on('end', (data) => {
//         res.status(200).send();
//     });
// });

var a = [1, 3, 2, 5, 3, 4]
var rtAuJson = JSON.stringify(a);
fs.writeFile('rtTraffic.txt', rtAuJson, function(err) {
    if (err) throw err;
    console.log('write JSON into TEXT');
});

app.get('/', (req, res) => {
    readStream.pipe(res);
    setTimeout(() => {
        readStream.unpipe(res);
        res.status(200).send();
    }, 10);
});
app.listen(3000);