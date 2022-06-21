let schedule = require('node-schedule')
let moment = require('moment')
let a = 0;
schedule.scheduleJob('*/5 * * * * *', function () {

    if(a == 0){
        console.log('test');
        a = 1;
    }
    
})