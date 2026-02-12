const nodemailer = require('nodemailer');

sendMail('')
async function sendMail(email, data) {
    var transporter = nodemailer.createTransport({
        service: "Gmail",
        auth: {
            user: "",
            pass: ""
        }
    });

    var options = {
        from: "",
        to: email,
        cc: "",
        bcc: "",
        subject: "",
        text: data,
    };
    transporter.sendMail(options, function(error, info) {
        if (error) {
            console.log(error);
        } else {
            console.log("訊息發送: " + info.response);
        }
    });
}