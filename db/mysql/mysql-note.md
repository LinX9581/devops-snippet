* 如果你家資料量大但關聯性高時 -> 不適合用Cassandra
* 如果你家資料量大但需要OLAP分析時 -> 不適合用Cassandra
* 如果你家資料又少關聯性又高時 -> 當然不要用啊
* query 拿来执行 select 更好一些，execute 哪里执行 update | insert | delete

大量mysql更新方式建議
https://speakerdeck.com/techverse_2022/our-automation-tool-for-migrating-1800-mysql-instances-in-only-six-months?slide=88


mysql patition redis
https://kalacloud.com/blog/how-to-edit-mysql-configuration-file-my-cnf-ini/
https://medium.com/10coding/node-js-%E4%BD%BF%E7%94%A8-redis-%E5%85%A7%E5%AD%98%E4%BE%86%E5%AD%98%E5%8F%96%E6%9C%AC%E5%9C%B0%E8%B3%87%E6%96%99-9557660196f4

https://medium.com/17live-tech/mysql-partitioning-%E5%84%AA%E5%8C%96%E4%B9%8B%E8%B7%AF-fd8e8480789b

major-MySQLTuner-perl-b6f8f9f


https://github.com/bertvv/ansible-role-mariadb/blob/master/tasks/main.yml
步驟爆幹長
mysql 5.7
使用 auth_socket 認的是系統的user id

mysql 8.0 密碼認證
identified with mysql_native_password
caching_sha2_password
sha2_password
