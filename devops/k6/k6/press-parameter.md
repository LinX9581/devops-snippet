# 其他高QPS參數設置
## mysql
max_connections        = 20000
max_connect_errors = 10000   # 太多連線數or太多error會把該VM IP鎖住
innodb_buffer_pool_size = 4G
innodb_lock_wait_timeout = 50

## nginx
worker_connections
keepalive
qps=10000 , 連線時間=100ms 推算長連線=1000
keepalive 設置為10%到30%。

如果設置太短
假設
第一個10毫秒有 100個請求 並且處理完畢 空閒100個連線
下一個10毫秒有 150個請求 減掉前面空閒100 還有50個連線需要重新建立
如果 keepalive = 10 則需要重新建立 50-10=40連線需要建立

## php-fpm
/etc/php/7.4/fpm/pool.d/www.conf
pm = static
pm.max_children = 4000

while [ 1 ]; do service php7.4-fpm status | grep 'Status' | cut -c 25-49; sleep 1; echo '------'; done

查看單台 tcp 連線數 ( node_exporter 有監控)
netstat -ant | wc -l
while [ 1 ]; do netstat -ant | wc -l; sleep 1; echo '------'; done

## linux 內核
https://blog.csdn.net/weixin_42293387/article/details/116051380
https://cloud.tencent.com/developer/article/1743145
error: Cannot assign requested address
每個連線都會占用port 預設60秒才會釋放
* 直接改文件
more /etc/sysctl.conf 
* 指令改參數
sysctl -w net.ipv4.tcp_fin_timeout=15 # 但調這個沒用 
sysctl -w net.ipv4.tcp_tw_reuse=1     # 釋放後會給新的port使用    #####這個最重要 會大量降低 time wait
sysctl -w net.ipv4.tcp_tw_recycle=1
sysctl -p                             # 不重開立即執行 , 但重開機還是會失效
sysctl -a | grep port_range            # port range # 每個連線都會占用port
net.ipv4.ip_local_port_range = 50000    65000

sysctl -a | grep conntrack            # 查看目前 net.nf_conntrack_max
sysctl -w net.netfilter.nf_conntrack_max=262144
sysctl -w net.nf_conntrack_max=262144
sysctl -p //生效
ONNTRACK_MAX = RAMSIZE (in bytes) / 16384 / (ARCH / 32)
記憶體 = 16G
16*1024*1024*1024/16384/後面VM數

sysctl -w net.core.somaxconn=65535

## 語言差異
不同語言 最好都由nginx 代理
* nodejs
因是單線程執行程式 因此在多核心的表現不佳
需透過 Cluster 能在單個 Node.js 進程中啟動多個子進程，這些子進程可以在多個 CPU 核心上並行運行。每個子進程都運行獨立的 Node.js 程式

* php 
多線程執行程式 一種共享資源的語言，多線程環境下需要注意線程安全和資源競爭的問題
所以調整php-fpm非常重要

* java
Java 使用的是 Java 虛擬機（JVM）執行 Java 程式碼
在 Tomcat 中，通常會使用 Java Servlet 和 JSP 技術來開發 Web 應用程式

Tomcat 支援多種不同的執行模式，包括獨立模式、多執行緒模式和集群模式等。在多執行緒模式下，Tomcat 可以同時處理多個 HTTP 請求，從而提高系統的效能和吞吐量。您可以透過調整 Tomcat 的相關參數，如 maxThreads、minSpareThreads、maxSpareThreads、acceptCount
調整方式 類似 php-fpm 