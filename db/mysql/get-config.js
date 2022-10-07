const query = require('./mysql');


async function test (){
    // 數值為 記憶體80% ； cloud sql 規定記憶體35%
    let innodb_buffer_pool_size = await query(`SHOW VARIABLES LIKE 'innodb_buffer_pool_size';`)
    // console.log(innodb_buffer_pool_size[0].Value);

    // 查看使用過的最高連線數
    let max_used_connections = await query(`SHOW VARIABLES LIKE 'max_used_connections';`)
    console.log(max_used_connections);

    
    // 目前設定的最大連線數
    let max_connections = await query(`SHOW VARIABLES LIKE 'max_connections';`)
    console.log(max_connections[0].Value);
    
    // 查看使用過的最高連線數
    let Threads_connected = await query("show status where `variable_name` = 'Threads_connected';")
    console.log(Threads_connected[0].Value);
    // 目前process
    // let process = await query(`SHOW PROCESSLIST;`)
    // console.log(process);
}

var t=setInterval(test,1000);
// clearInterval(t);

// mysqlSleep()
async function mysqlSleep(){
    query(`SELECT SLEEP(5);`)
    console.log('done');
}


// SHOW VARIABLES LIKE 'innodb_buffer_pool_size';