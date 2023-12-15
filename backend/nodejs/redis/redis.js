const redis = require('redis');

// 替換成遠端 Redis 伺服器的 IP 地址和端口
const REDIS_HOST = '172.16.200.13';
const REDIS_PORT = "6379"; // 通常是 6379，除非有更改
// const REDIS_PASSWORD = '你的密碼'; // 如果有設置的話

// 創建一個 Redis 客戶端
const client = redis.createClient({
    url: `redis://${REDIS_HOST}:${REDIS_PORT}`,
    // password: REDIS_PASSWORD // 如果沒有設置密碼，這一行可以省略
});

// 監聽錯誤事件
client.on('error', (err) => {
    console.log('Redis Client Error', err);
});

// 連接到 Redis
client.connect();

// 寫入資料
const key = 'testKey';
const value = 'Hello Redis!';

// 使用異步函數來處理寫入和讀取
async function runRedisExample() {
    try {
        // // 寫入資料
        // await client.set(key, value);
        // console.log(`資料寫入成功: ${key} -> ${value}`);

        // 讀取資料
        const result = await client.get(key);
        console.log(`從 Redis 讀取的資料: ${result}`);
    } catch (err) {
        console.error('操作 Redis 時出錯', err);
    } finally {
        // 關閉客戶端連接
        client.quit();
    }
}

// 執行範例
runRedisExample();
