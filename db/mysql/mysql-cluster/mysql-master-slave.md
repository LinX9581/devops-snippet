https://www.youtube.com/watch?v=His5wRvAKY0&ab_channel=ReadyDedisLLC

create user 'rep_user'@'172.16.2.4' identified by '00000000';


CHANGE MASTER TO MASTER_USER='replication_user', MASTER_PASSWORD='EXAMPLE_PASSWORD' FOR CHANNEL 'group_replication_recovery';

CHANGE MASTER TO MASTER_HOST='172.16.2.6', MASTER_USER='rep_user', MASTER_PASSWORD='00000000', MASTER_LOG_FILE='mysql-bin-000001', MASTER_LOG_POS=1390;



CREATE USER 'dev'@'172.16.2.4' IDENTIFIED BY '00000000';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'172.16.2.4' WITH GRANT OPTION;
FLUSH PRIVILEGES;