let schedule = require('node-schedule')
let moment = require('moment')
let now = moment().format('YYYY/MM/DD HH:mm:ss')
console.log(now);

//每10 30秒
schedule.scheduleJob('10,30 * * * * *', function() {
        let now = moment().format('YYYY/MM/DD HH:mm:ss')
        console.log(now);
    })
    //每30分鐘
schedule.scheduleJob('* */30 * * * *', function() {
    let now = moment().format('YYYY/MM/DD HH:mm:ss')
    console.log(now);
})

let rule = new schedule.RecurrenceRule();
rule.second = [10, 40]; // 每隔 10 秒执行一次
schedule.scheduleJob(rule, function() {
    // let now = moment().format('YYYY/MM/DD HH:mm:ss')
    // console.log(now);
})

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}


var jobs = {}

function createJob(jobid, jobtime) {
    jobs[jobid] = schedule.scheduleJob(jobtime, function() {
        // do something you want...
    });
}

function deleteJob(jobid) {
    jobs[jobid].cancel();
}
let b = 1;
schedule.scheduleJob('0 31 15 * * *', async function() {
        test()
    })
    // schedule stop
    // test()
async function test() {
    let a = schedule.scheduleJob('*/3 * * * * *', function() {
        console.log('test');
        b += 1;
        console.log(b);
        if (b == 4) {
            a.cancel();
        }
    })
}