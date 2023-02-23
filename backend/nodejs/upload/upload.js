var express = require('express')
var multer = require('multer')
var app = express();
const path = require('path')
const fs = require('fs')

app.use(express.static('public'));

var storage = multer.diskStorage({
    destination: function(req, file, cb) {

        // Uploads is the Upload_folder_name
        cb(null, "./")
    },
    filename: function(req, file, cb) {
        console.log(file);
        cb(null, file.fieldname + "-" + Date.now() + ".jpg")
    }
})

const maxSize = 1 * 1000 * 1000;

var upload = multer({
    storage: storage,
    limits: { fileSize: maxSize },
    fileFilter: function(req, file, cb) {

        // Set the filetypes, it is optional
        var filetypes = /jpeg|jpg|png/;
        var mimetype = filetypes.test(file.mimetype);

        var extname = filetypes.test(path.extname(
            file.originalname).toLowerCase());

        if (mimetype && extname) {
            return cb(null, true);
        }

        cb("Error: File upload only supports the " +
            "following filetypes - " + filetypes);
    }

    // mypic is the name of file attribute
}).single("mypic");

app.get('/', function(req, res) {
    res.sendFile(__dirname + '/index.html');
    console.log("asd")
});

app.post('/uploadphoto', function(req, res) {
    console.log('get file');
    upload(req, res, (err) => {
        if (err) console.log(err);
        else {
            res.send({ result: 'success' });
        }
    });
});
app.listen(4000, () => console.log(`Server started on port 4000`));