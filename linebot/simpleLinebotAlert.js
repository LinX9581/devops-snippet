const linebot = require('linebot')
const schedule = require('node-schedule');
const fetch = require('node-fetch');

const rule = new schedule.RecurrenceRule();
//提醒間隔
// rule.minute = [0,5,10,15,20,25,30,35,40,45,50,55]; 
rule.minute = [0, 10, 20, 30, 40, 50];

let bot = linebot({
    channelId: '',
    channelSecret: '',
    channelAccessToken: ''
});

//要通知的Line ID
let masterId = "C082408192da4c47ae5f54654196dffa2";
let myId = "Ue4c93d4c9216495aeae09328ebb8aefe";

let hostname = [
    ['https://', 'websiteName'],
    ['https://', 'websiteName'],
    ['https://', 'websiteName'],
    ['https://', 'websiteName'],
    ['https://', 'websiteName'],
    ['https://', 'websiteName']
]

schedule.scheduleJob(rule, async function() {
    for (var i = 0; i < hostname.length; i++) {
        const res = await fetch(hostname[i][0])
        if (res.status != 200) {
            bot.on('message', async function(event) {
                console.log(event.message.text)
                bot.push(masterId, hostname[i][1] + " 網站已死 error code: " + res.status);
                bot.push(myId, hostname[i][1] + " 網站已死 error code: " + res.status);
                console.log(hostname[i][1] + "error code: " + res.status)
            });
        }
    }
    console.log("所有網站都正常")
})


const linebotParser = bot.parser(),
    express = require('express'),
    router = express.Router();
router.post('/', linebotParser);

//搭配監控系統的預警
router.post('/ram', async function(req, res, next) {
    console.log("記憶體標高!")
    bot.push(masterId, "記憶體標高!");
    // bot.push(myId, "test!");
});
router.post('/cpu', async function(req, res, next) {
    console.log("CPU標高!")
    bot.push(masterId, "CPU標高!");
    // bot.push(myId, "test!");
});
router.post('/disk', async function(req, res, next) {
    console.log("硬碟空間不夠!")
    bot.push(masterId, "硬碟空間不夠!");
    // bot.push(myId, "test!");
});

module.exports = router;