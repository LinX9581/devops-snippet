* Install
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo -u postgres psql

* Create Database & User
CREATE DATABASE mydb;
CREATE USER dev WITH ENCRYPTED PASSWORD '00000000';
GRANT ALL PRIVILEGES ON DATABASE mydb TO dev;

* Import
psql -U postgres -d www_ga4 -f www_ga4.sql

* 顯示使用者和 databases
\l          # list all databases
\c mydb     # connect to mydb
\du         # list all users
\dt         # list all tables in the current database
\s          # display command history
+ more

* 權限控管
/etc/postgresql/12/main/pg_hba.conf

* pgAdmin
docker run -p 3011:80 \
    -e 'PGADMIN_DEFAULT_EMAIL=dev@gmail.com' \
    -e 'PGADMIN_DEFAULT_PASSWORD=00000000' \
    -d dpage/pgadmin4

* 連線
確保/etc/postgresql/12/main 設定檔使用者都是 postgres
而且 
postgresql.conf listen 必須是 *
pg_hba.conf 範圍要對

psql -h 172.20.11.22 -p 5432 -U dev -d mydb


* mysql -> postgresql

sudo apt-get update
sudo apt-get install pgloader

psql 
ALTER DATABASE www_ga4 SET search_path TO public, www_ga4;

mysqldump -u root -p www_ga4 > www_ga4.sql

a.load
```
LOAD DATABASE
     FROM mysql://test:00000000@localhost/www_ga4
     INTO postgresql://dev:00000000@localhost/www_ga4

 WITH include no drop, create tables, no truncate,
      create indexes, reset sequences, foreign keys

  SET work_mem to '16MB', maintenance_work_mem to '512 MB';
```

pgloader a.load