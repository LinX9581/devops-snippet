# nginx
* keepalive_timeout
時間設過長會耗資源

Default:    keepalive_timeout 75s;
Context:    http, server, location
keepalive_timeout 20s;

* keepalive_requests
每個連線10000個請求就會被斷開
高QPS 需調高此參數

Default:    keepalive_requests 100;
Context:    http, server, location
keepalive_requests 10000;

* send_timeout
客戶端傳送檔案的時間

Default: 60s

* client_body_timeout client_header_timeout
client 發送 req body -> server的時間

Default: 60s

* proxy_connect_timeout
前端打後端API 後端如果超過60秒 會直接504

Default: 60s

# Mysql

set innodb_lock_wait_timeout=100;

* Lock wait timeout exceeded
后提交的事务等待前面处理的事务释放锁，但是在等待的时候超过了mysql的锁等待时间，就会引发这个异常。

* Dead Lock
两个事务互相等待对方释放相同资源的锁，从而造成的死循环，就会引发这个异常。

# Js

後端如果超過120秒沒回應 client強制斷開
```
let pvStageStatus = await fetch('https://linx.com/checkData', {
    signal: AbortSignal.timeout(120000),
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
})
```

後端超過120秒 後端自己斷開
express 
var server = app.listen(port, host, function() {
    console.log('Express server listening on port ' + port);
});
server.timeout = 1200000;
