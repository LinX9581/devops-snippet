const Mysql = require('mysql2/promise');
const pool = Mysql.createPool({
    host: config.mysql.host,
    user: config.mysql.user,
    password: config.mysql.password,
});

module.exports = pool