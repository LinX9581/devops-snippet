const moment = require('moment')
//-1天
let yesterday = moment().subtract(1, 'd').format('YYYY-MM-DD');
//轉成 165651231
let dateToString = moment(new Date()).valueOf()

let formatTime = moment(dateToString).format()
console.log(dateToString);
console.log(formatTime);

let afterSelectTime = new moment().format('YYYY-MM-DD HH:mm:ss')

let a = '2023-02-02'
let now = moment(a,'YYYY-MM-DD HH:mm:ss')
let b = '2023-01-30'
console.log(now.diff(b,'day'));