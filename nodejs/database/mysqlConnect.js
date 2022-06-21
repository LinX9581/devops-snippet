import Mysql from 'mysql2/promise'
const pool = Mysql.createPool({
    host: '127.0.0.1',
    user: 'dev',
    password: '00000000',
});

// 這邊 try catch 會不知道error在哪
// let query = async function (query,data) {
//     try {
//         const rows = await pool.query(query,data);
//         return rows[0];
//     } catch (err) {
//         console.log('SQL ERROR => ' + err);
//         return err.stack;
//     }
// }
export default pool