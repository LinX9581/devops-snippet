const fs = require('fs');
const fetch = require('node-fetch');
const FormData = require('form-data');

const filePath = `/1.jpg`;
const form = new FormData();
const stats = fs.statSync(filePath);
const fileSizeInBytes = stats.size;
const fileStream = fs.createReadStream(filePath);
form.append('mypic', fileStream, { knownLength: fileSizeInBytes });
var requestOptions = {
    method: 'POST',
    headers: {
        "Content-Type": "multipart/form-data;",
    },
    body: form,
};

const options = {
    method: 'POST',
    credentials: 'include',
    body: form
};

fetch('http://127.0.0.1:4000/uploadphoto', {...options })
    .then(res => {
        if (res.ok) return res;
        throw res;
    });
// use curl
// curl -H "Content-type: multipart/form-data" -F "mypic=@/1.jpg" http://127.0.0.1:4000/uploadphoto