major-MySQLTuner-perl-b6f8f9f
## install
基本安裝 & 建立使用者
sudo apt install mariadb-server mariadb-client -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation
全部Y

## 常見問題
* import export error : The user specified as a definer (該table綁定特定使用者而該使用者已不在)

把原來的作者改掉 或者加指令 直接繞過
mysqldump --single-transaction -u root -p mydb > mydb.sql

* check all user
SELECT User, Host FROM mysql.user;

* create user
CREATE DATABASE wp_db;
CREATE USER 'dev'@'localhost' IDENTIFIED BY '00000000';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

* drop user
DROP USER 'username'@'host';

* change user password
SET PASSWORD FOR 'dev-holywater'@'localhost' = PASSWORD('xO7mjOy3()Z%');

* restart Mysql
sudo service mysql restart

## 特定網段連線
CREATE USER 'dc'@'172.16.2.0/24' IDENTIFIED BY 'now@28331543';
GRANT ALL PRIVILEGES ON *.* TO 'dc'@'172.16.2.0/24' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'dc'@'172.16.2.42' WITH GRANT OPTION;
FLUSH PRIVILEGES;

DROP USER 'dc'@'172.16.2.10';
DROP USER 'dc'@'172.16.2.42';
DROP USER 'dc'@'172.16.2.0/24';

* 給不同使用者 有不同權限
GRANT <privileges> ON <database>.<table> TO "myuser"@"localhost";
* 只開放特定權限、特定table 給特定使用者
grant select, insert, update, delete on testdb.* to common_user@'localhost'
* 拔除特定權限
REVOKE <privileges> ON <database>.<table> FROM "myuser"@"localhost";
* 看特定使用者的所有權限
SHOW GRANTS FOR "myuser"@"localhost";

* 匯入 匯出
mysql -u root -p test < /var/www/test.sql
mysqldump -u root -p test > /var/www/test_t.sql
mysqldump -h 35.194.175.118 -u root -p test > /var/www/test.sql

* 變更指定使用者的權限
UPDATE user SET host='%' WHERE User='developer';
FLUSH PRIVILEGES;

* 部分Mysql預設會被裝插件 導致登入Root不用密碼
update mysql.user set plugin=null where user='root';
flush privileges;

* table 之間有 foreign key ，導致table 不能新增修改時
SET GLOBAL FOREIGN_KEY_CHECKS=0;

## 完整清除 mysql
cp -r /var/lib/mysql /home/ubuntu/
mkdir /home/ubuntu/etc_mysql
cp -r /etc/mysql /home/ubuntu/etc_mysql
rm -rf /etc/mysql
rm -rf /var/lib/mysql
apt-get purge mariadb-server mariadb-* mysql-*
apt-get autoremove

## Slow log & Query Log開啟狀態
use mysql;
show variables like '%slow_query_log%';
show variables like '%quer%';
show variables like 'general_log_file'
修改位置
Mariadb
/etc/mysql/mariadb.conf.d
Mysql
/etc/mysql/my.cnf
CentOS
/etc/my.cnf
/etc/my.cnf.d/mariadb
開啟慢日誌功能
slow_query_log = 1
查詢時間超過 2 秒則定義為慢查詢（可自行改秒數）
long_query_time = 2
將產生的 slow query log 放到你指定的地方
slow_query_log_file = /var/log/mysql/slow_query.log
log-output=FILE

Query Log
general-log=1
general_log_file="/var/log/mysql/general_log.log"

改完重啟
sudo service mysql restart


# CDC & 批次同步比較
https://medium.brobridge.com/cdc-%E8%88%87%E6%89%B9%E6%AC%A1%E8%99%95%E7%90%86%E7%9A%84%E8%B3%87%E6%96%99%E5%BA%AB%E5%90%8C%E6%AD%A5%E6%9C%89%E4%BB%80%E9%BA%BC%E5%B7%AE%E7%95%B0-cb1e69437d00

# Gravity 
https://medium.com/brobridge/%E4%BB%A5-gravity-%E7%84%A1%E7%97%9B%E6%8F%90%E9%AB%98%E8%B3%87%E6%96%99%E5%BA%AB%E7%9A%84%E4%BD%B5%E7%99%BC%E6%9F%A5%E8%A9%A2%E8%83%BD%E5%8A%9B-859cbc49aa6e

## Gravity
安裝
https://www.twblogs.net/a/5d40832dbd9eee51fbf99ff6
官方
https://github.com/moiot/gravity/blob/master/docs/2.0/01-quick-start-en.md

# kafka
https://medium.com/@chihsuan/introduction-to-apache-kafka-1cae693aa85e

kafka & pub/sub
https://hsiehjenhsuan.medium.com/kafka-%E5%AF%A6%E4%BD%9C%E7%B4%80%E9%8C%84-78399b7abe55

# grafana 參數
https://twgreatdaily.com/GbDIr3EBnkjnB-0z63vH.html

# 壓力測試
https://www.796t.com/content/1551959778.html