## 假設情境
假設情境是 新聞網站
一天流量200萬
突發事件 一分鐘內同時在線使用者有可能會到 6000
假設系統是 Linux 2C4G Java Tomcat 最前面有一台 Nginx

## K6 設定
import http from "k6/http";
import { sleep } from "k6";

export let options = {
  stages: [
    { duration: "30s", target: 200 },  // 30 秒內增加到 200 個使用者
    { duration: "1m", target: 400 },   // 1 分鐘內增加到 400 個使用者
    { duration: "2m", target: 400 },   // 保持 400 個使用者在線 2 分鐘
    { duration: "1m", target: 600 },   // 1 分鐘內增加到 600 個使用者
    { duration: "2m", target: 600 },   // 保持 600 個使用者在線 2 分鐘
    { duration: "1m", target: 800 },   // 1 分鐘內增加到 800 個使用者
    { duration: "2m", target: 800 },   // 保持 800 個使用者在線 2 分鐘
    { duration: "30s", target: 0 },    // 減少使用者至 0
  ],
};

export default function () {
  const res = http.get("http://34.81.251.143"); // prod
  sleep(Math.random() * (60 - 30) + 30); // 隨機停留 30 到 60 秒
}

ps -eLf | grep java | wc -l 
大概落在 150以內

while [ 1 ]; do ps -eLf | grep java | wc -l; sleep 1; echo '------'; done

## 測試資料

* 2C 5G * 1 
http_req_duration..............: avg=3.58s    min=189.92ms med=675.83ms max=21.05s  p(90)=10.41s   p(95)=12.09s

keepalive_timeout 10;
maxThreads="300"
acceptCount="500"
connectionTimeout="10000"


* 2C 5G *1
http_req_duration..............: avg=3.58s    min=194.29ms med=767.87ms max=22.26s  p(90)=10.87s   p(95)=12.76s

keepalive_timeout 10;
maxThreads="200"
acceptCount="500"
connectionTimeout="10000"

* 2C 5G *1
http_req_duration..............: avg=3.77s    min=188.87ms med=1.07s    max=14.6s   p(90)=9.92s    p(95)=10.73s 

keepalive_timeout 10;
maxThreads="75"
acceptCount="500"
connectionTimeout="10000"

* 2C 5G *1
http_req_duration..............: avg=3.83s    min=198.91ms med=673ms    max=20.77s  p(90)=10.73s   p(95)=12.25s

keepalive_timeout 10;
maxThreads="150"
acceptCount="500"
connectionTimeout="10000"

因 Java 線程在 100~125是最穩定的狀態 所以 maxThreads 設在125左右反而最適當
要再更高只能調CPU數量


## GA 即時對比 K6

GA 18000 1分鐘 800 六台平均一台線程48
相當於 k6 400 VUs

k6 600 VUs = 60~70 threads