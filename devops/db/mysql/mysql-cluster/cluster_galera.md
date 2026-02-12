## Mariadb Cluster
* 安裝DB
sudo apt install mariadb-server mariadb-client -y
* 新增 Cluster 設定檔
要Cluster的DB都要新增下面這些到
/etc/mysql/mariadb.conf.d/50-server.cnf
```
[mysqld]
binlog_format=ROW
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
bind-address=0.0.0.0

# Galera Provider Configuration
wsrep_on=ON
wsrep_provider=/usr/lib/galera/libgalera_smm.so

# Galera Cluster Configuration
wsrep_cluster_name="test_cluster"
wsrep_cluster_address="gcomm://First_Node_IP,Second_Node_IP,Third_Node_IP"

# Galera Synchronization Configuration
wsrep_sst_method=rsync

# Galera Node Configuration
wsrep_node_address="This_Node_IP"
wsrep_node_name="This_Node_Name"
```
[wsrep_sst_method 各版本差異](https://www.itread01.com/p/1405754.html)

* 開防火牆
3306,4567,4568,4444

* 重啟DB
sudo systemctl stop mysql
```
master都需要這樣啟動
sudo galera_new_cluster

node 照舊
service mysql restart
```

* 檢查節點
mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size'"

### 修復節點
* 狀況1
全部節點一起重開機
看每一台的 grastate.dat
more /var/lib/mysql/grastate.dat
最後一台開機的 safe_to_bootstrap 參數會最大
就讓該台當 master node , 重新設定 50-server.conf
在 wsrep_cluster_address 把該台IP放前面
重建一個cluster
sudo galera_new_cluster
之後其他台 
service mysql stop, service mysql restart 
就會全部串回來
如果master node 已改成別台 wsrep_cluster_address 的IP也要改
* 狀況2
其中一台掛
重開後 service mysql restart
就會重新串回

[參考](https://braineuron.app/fan-yi-ru-he-xiu-fu-mariadb-galera-cluster/)

## MariaDB Loadbalance
A = LB IP
B = DB
instant A's nginx setting
```
stream{
	server {
		listen 3307;
		proxy_pass stream_backend;
		proxy_connect_timeout 1s;
	}
	upstream stream_backend {
		server BIP:3306; #instant B
	}
}

此時連自己的 3307 port 會連到B機器的mariadb
mysql --host=AIP --port=3307 --user=aa --password
```

