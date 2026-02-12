const Mysql = require('mysql2/promise');
const poolCluster = Mysql.createPoolCluster({
    canRetry: true,
    removeNodeErrorCount: 10,
    defaultSelector: 'RANDOM',
    removeNodeWaitTime: 1000,
});
poolCluster.add('server1', {
  host: '34.81.90.156',
  port: '3306',
  user: 'analytics_fb',
  password: '1c6fb4eae2ddf6fbad3a48c7ed056f35',
});
poolCluster.add('server2', {
  host: '172.16.200.12',
  port: '3306',
  user: 'analytics_fb',
  password: '1c6fb4eae2ddf6fbad3a48c7ed056f35',
});
const pool = poolCluster.of('*');
let query = async function(query, data) {
    try {
        const rows = await pool.query(query, data);
        return rows[0];
    } catch (err) {
        console.log('ERROR => ' + err);
        return err;
    }
}
module.exports = query