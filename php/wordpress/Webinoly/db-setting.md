設定 Mysql
建立使用者&DB

CREATE DATABASE wp_db;
CREATE USER 'dev'@'localhost' IDENTIFIED BY '00000000';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
建立對外DB

CREATE USER 'deve'@'%' IDENTIFIED BY '00000000';
GRANT ALL PRIVILEGES ON *.* TO 'deve'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;