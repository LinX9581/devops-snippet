import mysql from './mysqlConnect'

test()
async function test(){
    let a = await mysql.query('select sdfsdf')
    console.log(a[0]);
}

