## 環境
Linux Nginx Docker-compose ELK filebeat git

## 執行 ELK
* 執行腳本
sh elk.sh

有改設定就執行以下指令
docker-compose up --detach --build logstash

## 要收 log 的 VM 要裝 filebeat
* 執行腳本
sh filebeat.sh

主要會改兩個設定檔
elasticsearch.yml 
logstash

只需要確保 /etc/filebeat/filebeat.yml
INDEX_NAME 要和 Logstash 的設定檔 log_topics 匹配

## 顯示數據
左上選單 -> Discover

## ERROR
0. 7.5版以下的 ELK index 要在介面建立

1. log 無法 match
Grok match 工具
https://grokdebug.herokuapp.com/

sample
確保 nginx log 格式
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
```
162.158.5.135 - - [17/Nov/2021:07:47:40 +0000] "GET / HTTP/2.0" 200 384 "-" "curl/7.64.0" "104.199.233.193"

%{IPORHOST:[nginx][access][remote_ip]} - %{DATA:[nginx][access][user_name]} \[%{HTTPDATE:[nginx][access][time]}\] \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\"
```

2. filebeat 跑在背景關不掉
rm -rf /var/lib/filebeat/filebeat.lock
sudo systemctl stop filebeat
sudo pkill -f filebeat
sudo systemctl start filebeat
sudo systemctl enable filebeat

3. 不同log寫入不同index
https://blog.csdn.net/wsdc0521/article/details/106308441

4. logstash 官方不同log的範例
https://www.elastic.co/guide/en/logstash/6.8/logstash-config-for-filebeat-modules.html#parsing-nginx

5. 搜尋用法
在搜尋列才能用包含和不包含
NOT (nginx.access.agent : *bot*)
filter 才能絕對符合

# 其他問題
---
## index相關
elasticsearch.yml 增加
xpack.security.authc.api_key.enabled: true

* 查看當前 index shards
curl -u user:password -X GET "http://127.0.0.1:9200/_cat/indices?v"

* 合併1月份索引成1個
curl -u user:password -X POST "http://172.18.0.1:9200/_reindex" -H 'Content-Type: application/json' -d'
{
  "source": {
    "index": "backed_log_nginx_access-2024.01.*"
  },
  "dest": {
    "index": "backed_log_nginx_access-2024.01"
  }
}
'

* 查看目前所有index
curl -u user:password 172.18.0.1:9200/_cat/indices
* 刪除index
curl -u user:password -X DELETE "localhost:9200/index_prefix-access-2023.03.06?pretty"

* 每日砍index 
sudo nano /etc/cron.d/elk_cron_job
0 0 * * * root /var/www/delete_index.sh

## 記憶體不夠大
調整 docker-compose.yml 的 JAVA 參數

## 帳號相關
連進elastic container 執行以下指令
bin/elasticsearch-users useradd nnviewer -p 1234 -r viewer

## 安裝方式
nginx access log 1~2G 
每秒量訪問 50~150
每 1 GB RAM，大約可處理 10 GB 查詢資料
每 1vCPU core 大約可處理 20~40 GB 查詢資料
https://blog.johnwu.cc/article/elk-hardware-specification.html

## 參考
* 官方
https://github.com/deviantony/docker-elk

1. 參考影片
https://www.youtube.com/watch?v=TaW5JFKLeeg&ab_channel=XavkiEn
https://www.youtube.com/watch?v=iWFasUQ1tNQ&ab_channel=%E6%B2%88%E5%BC%98%E5%93%B2
https://github.com/twtrubiks/docker-elk-tutorial/tree/elk-7.6.0/docker-elk

建立參考文章 (docker)
https://wsgzao.github.io/post/efk/

2. grok
http://doc.yonyoucloud.com/doc/logstash-best-practice-cn/filter/grok.html

3. logstash
https://www.elastic.co/guide/en/logstash/6.8/logstash-config-for-filebeat-modules.html#parsing-nginx

4. 一次紀錄多筆LOG
https://blog.csdn.net/wsdc0521/article/details/106308441

5. index 設計
https://cloud.tencent.com/developer/article/1395231

6. 切index
https://ithelp.ithome.com.tw/articles/10244575

https://jsbin.com/qejufid/5/edit?html,css,js

* 錯誤參考
https://www.cnblogs.com/zhi-leaf/p/8484337.html