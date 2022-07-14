# 其他高QPS參數設置
## mysql
max_connections        = 20000
max_connect_errors = 10000   # 太多連線數or太多error會把該VM IP鎖住
innodb_buffer_pool_size = 4G
innodb_lock_wait_timeout = 50

## nginx
worker_connections

## php-fpm
/etc/php/7.4/fpm/pool.d/www.conf
pm = static
pm.max_children = 4000

while [ 1 ]; do service php7.4-fpm status | grep 'Status' | cut -c 25-36; sleep 1; echo '------'; done

查看單台request
netstat -ant | wc -l
while [ 1 ]; do netstat -ant | grep 172.16.2.24:80 | wc -l; sleep 1; echo '------'; done

## linux 內核
https://blog.csdn.net/weixin_42293387/article/details/116051380
error: Cannot assign requested address
每個連線都會占用port 預設60秒才會釋放
* 直接改文件
more /etc/sysctl.conf 
* 指令改參數
sysctl -w net.ipv4.tcp_fin_timeout=15 # 但調這個沒用 
sysctl -w net.ipv4.tcp_tw_reuse=1     # 釋放後會給新的port使用
sysctl -w net.ipv4.tcp_tw_recycle=1
sysctl -p # 不重開立即執行

port range # 每個連線都會占用port
sysctl -a |grep port_range
net.ipv4.ip_local_port_range = 50000    65000

https://cloud.tencent.com/developer/article/1743145
查看目前 net.nf_conntrack_max
sysctl -a | grep conntrack
sysctl -w net.netfilter.nf_conntrack_max=262144
sysctl -w net.nf_conntrack_max=262144
sysctl -p //生效
ONNTRACK_MAX = RAMSIZE (in bytes) / 16384 / (ARCH / 32)
記憶體 = 16G
16*1024*1024*1024/16384/後面VM數

sysctl -w net.core.somaxconn=65535