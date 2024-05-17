## 查看 背景執行的Thread
Thread
https://ithelp.ithome.com.tw/articles/10297649

* 查詢所有node 執行的路徑   
pwdx $(ps -C "node" --format pid --no-headers)

* 查詢哪些port被占用
netstat -tnlp

* 查看源站 port
nc -zvw1 107.167.0.0 80
z->只掃描不傳送 v->顯示掃描訊息 w3等待三秒

* 查看node的詳細
ps -fC node

* 查詢哪些程式在執行
ps aux | grep node

* 殺掉特定 Port 的 Thread
fuser -k 80/tcp

* 殺掉特定 Thread ID 
kill -9 12413
