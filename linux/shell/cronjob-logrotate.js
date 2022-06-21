const { exec } = require('child_process');
var schedule = require('node-schedule');

console.log("start")
var rule = new schedule.RecurrenceRule();
rule.hour = 3;

schedule.scheduleJob(rule, function() { //每天凌晨兩點自動備份資料庫
    exec(`logrotate -vf /etc/logrotate.d/nginx`, (err, stdout, stderr) => {
        if (err) {
            // node couldn't execute the command
            return;
        }
        console.log("db-backup")
            // the *entire* stdout and stderr (buffered)
        console.log(`stdout: ${stdout}`);
        console.log(`stderr: ${stderr}`);
    });

});

exec(`dir`, (err, stdout, stderr) => {
    if (err) {
        return;
    }
    console.log(`stdout: ${stdout}`);
    console.log(`stderr: ${stderr}`);
});