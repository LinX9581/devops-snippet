let moment = require('moment')

// getLastWeek(1)

function getLastWeek(i) {
    let weekOfDay = parseInt(moment().format('E'));
    let last_monday = moment().subtract(weekOfDay + 7 * i - 1, 'days').format('YYYY-MM-DD'); //周一日期
    let last_sunday = moment().subtract(weekOfDay + 7 * (i - 1), 'days').format('YYYY-MM-DD'); //周日日期
    return [last_monday, last_sunday]
}

let gaDate = moment(new Date()).add(-1, 'days').format('d');
console.log(gaDate);
// console.log(gaDate.getDay());
// const date = moment("2015-07-02"); // Thursday Feb 2015
// const dow = date.day();
// console.log(dow);


// console.log(d);
// let day = d.getDay();
// console.log(day);

// console.log(getLastWeek(0)[0], getLastWeek(0)[1]);
// console.log(getLastWeek(1)[0], getLastWeek(1)[1]);
// console.log(getLastWeek(2)[0], getLastWeek(2)[1]);
// console.log(getLastWeek(3)[0], getLastWeek(3)[1]);
// console.log(getLastWeek(4)[0], getLastWeek(4)[1]);