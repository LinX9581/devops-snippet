const nodemailer = require('nodemailer');

sendMail('xxx@test.com')
async function sendMail(email, data) {
    var transporter = nodemailer.createTransport({
        host: 'smtp.office365.com',
        port: '587',
        auth: {
            user: "test@gmail.com",
            pass: "test"
        },
        secureConnection: false,
        tls: { ciphers: 'SSLv3' }
    });

    var options = {
        from: "test@gmail.com",
        to: email,
        cc: "test@gmail.com",
        bcc: "test@gmail.com",
        subject: "test",
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