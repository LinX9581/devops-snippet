# mysql install
apt install mariadb-server mariadb-client -y
sudo systemctl start nginx mariadb
sudo systemctl enable nginx mariadb

# Mysql 參數介紹
* 參數修改
/etc/mysql/mariadb.conf.d/

* 參數介紹
https://yunlzheng.gitbook.io/prometheus-book/part-ii-prometheus-jin-jie/exporter/commonly-eporter-usage/use-promethues-monitor-mysql

## 清除特定日期的資料庫並存在新 Table
CREATE TABLE post_pv_count_before_202307 LIKE post_pv_count;
INSERT INTO post_pv_count_before_202307 SELECT * FROM post_pv_count WHERE count_time < '2023-07-01';
DELETE FROM post_pv_count WHERE count_time < '2023-07-01';

# create view
create view year1_post_view as select * from table where date_sub(curdate(),interval 366 day) <= `post_create_date`;

## 記憶體相關
* innodb_buffer_pool_size
```
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
數值為 記憶體80%
cloud sql 規定記憶體35%
```
## 快取相關
* 快取開關
SHOW VARIABLES LIKE 'query_cache_type';
設1=打開
* 快取容量
SHOW VARIABLES LIKE 'query_cache_size';
* 查看快取狀況
show status like '%Qcache%';

## timeout
set innodb_lock_wait_timeout=100;

## CPU
* nnodb_read_io_threads
* innodb_write_io_threads
讀寫核心數 

* join_buffer_size
預設是128K 每一個proccess 占用128K

## connection 
* 查看使用過的最高連線數
show status like 'max_used_connections';

* 目前設定的最大連線數 預設為100
show variables like '%max_connections%';

* 永久更改連線數
/etc/mysql/mariadb.conf.d/50-server.cnf
max_connections = 10000

* thread斷開時可以快取到下一位user使用
show variables like 'thread_cache_size';
* Threads_created 太高則可以調高 thread_cache_size
show status like 'Threads%';

[優先參考](https://www.jishuwen.com/d/2qJJ/zh-tw)
[優先參考2](https://wulijun.github.io/2012/09/29/mysql-innodb-intro.html)
[參數介紹1](https://medium.com/@stock0139/mysql-%E5%8F%83%E6%95%B8%E5%84%AA%E5%8C%96-%E7%B3%BB%E5%88%97%E6%96%87-1-9696557faf30)
[參數介紹2](https://medium.com/@stock0139/mysql-%E5%8F%83%E6%95%B8-%E7%B3%BB%E5%88%97%E6%96%872-15db08f7e31)
https://ppfocus.com/0/di7936d1c.html
## 高併發
qps幾十，資料量數千萬 // 拆表分多次SQL 少用JOIN