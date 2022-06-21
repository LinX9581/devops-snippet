const nodemailer = require('nodemailer');

sendMail('xxx@test.com')
async function sendMail(email, data) {
    var transporter = nodemailer.createTransport({
        service: "Gmail",
        auth: {
            user: "test@test.com",
            pass: ""
        }
    });

    var options = {
        from: "test@test.com",
        to: email,
        cc: "test@test.com",
        bcc: "test@test.com",
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