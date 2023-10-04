## 環境
Linux Nginx Docker-compose ELK filebeat git

## 本地安裝 filebeat
```
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.15.1-amd64.deb
sudo dpkg -i filebeat-7.15.1-amd64.deb
filebeat modules enable nginx
```

更改 三個設定檔
docker-elk/logstash/pipeline/logstash.conf
/etc/filebeat/filebeat.yml
/etc/filebeat/modules.d/nginx.yml
內容都在 elk.sh

## 執行 ELK
* 官方ELK
git clone https://github.com/deviantony/docker-elk
cd /docker-elk
docker-compose up -d 

如果個別設定檔需要更改
docker-compose up --detach --build logstash

## filebeat tp logstash
filebeat -e

## elasticsearch 建立索引
左上選單 -> Stack Management -> Index Patterns -> Create index patterns

## 顯示數據
左上選單 -> Discover

## ERROR

1. log 無法 match
Grok match 工具
https://grokdebug.herokuapp.com/

sample
```
162.158.5.135 - - [17/Nov/2021:07:47:40 +0000] "GET / HTTP/2.0" 200 384 "-" "curl/7.64.0" "104.199.233.193"

%{IPORHOST:[nginx][access][remote_ip]} - %{DATA:[nginx][access][user_name]} \[%{HTTPDATE:[nginx][access][time]}\] \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\"
```

2. filebeat 跑在背景關不掉
rm -rf /var/lib/filebeat/filebeat.lock
或者 service filebeat stop
filebeat -e

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

* 查看目前所有index
curl -u user:password 172.18.0.1:9200/_cat/indices
* 刪除index
curl -u user:password -X DELETE "localhost:9200/index_prefix-access-2023.03.06?pretty"

* 每日砍index 
sudo nano /etc/cron.d/elk_cron_job
0 0 * * * root /var/www/delete_index.sh

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