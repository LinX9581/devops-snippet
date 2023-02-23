let schedule = require('node-schedule')
let moment = require('moment')

let nowdate = moment(new Date()).format('YYYY-MM-DD HH:mm:ss');
let nowTime = moment(new Date()).format('HH:mm:ss');

console.log(nowTime.split(':')[0]);
console.log(nowTime.split(':')[1]);