# JAVA
<Connector        
    port="80"
    protocol="org.apache.coyote.http11.Http11NioProtocol"                         
    maxThreads="500"                # netstat -nat | grep 80 | wc -l   平均落在300
    minSpareThreads="100"           
    minProcessors="100"             # ps -eLf | grep java | wc -l      平均落在200
    maxProcessors="1000"
    maxConnections="1000"
    connectionTimeout="50000"                         
    redirectPort="8443"
    enableLookups="false"                       
    maxPostSize="2097152"
    maxHttpHeaderSize="8192"
    compression="on"
    disableUploadTimeout="true"
    compressionMinSize="2048"
    acceptorThreadCount="8"
    compressableMimeType="text/html,text/plain,text/css,application/javascript,application/json,application/x-font-ttf,application/x-font-otf,image/svg+xml,image/jpeg,image/png,image/gif,audio/mpeg,video/mp4"
    URIEncoding="utf-8"
    tcpNoDelay="true"
    connectionLinger="5"
    server="server" 
/>
5台相同設定
80port : 550
JAVA   : 475

//找出當前thread數  平均落在 300 無連線狀態17
netstat -nat | grep 80 | wc -l
while [ 1 ]; do netstat -nat | grep 80 | wc -l; sleep 1; echo '------'; done

//找出所有thread數 平均落在 200 無連線狀態230
ps -eLf | grep java | wc -l
while [ 1 ]; do ps -eLf | grep java | wc -l; sleep 1; echo '------'; done

while [ 1 ]; do ps -eLf | grep php-fpm | wc -l; sleep 1; echo '------'; done

// 參數介紹
https://www.itread01.com/content/1545137663.html

https://www.gushiciku.cn/pl/gaXZ/zh-tw

伺服器中可以同時接收的連線數為maxConnections+acceptCount


# PHP
* 內存高 就用靜態
pm = static

pm.max_children = 350

; The number of child processes created on startup.
; Note: Used only when pm is set to 'dynamic'
; Default Value: min_spare_servers + (max_spare_servers - min_spare_servers) / 2
pm.start_servers = 150

; The desired minimum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.min_spare_servers = 150

; The desired maximum number of idle server processes.
; Note: Used only when pm is set to 'dynamic'
; Note: Mandatory when pm is set to 'dynamic'
pm.max_spare_servers = 250

; The number of seconds after which an idle process will be killed.
; Note: Used only when pm is set to 'ondemand'
; Default Value: 10s
;pm.process_idle_timeout = 10s;

; The number of requests each child process should execute before respawning.
; This can be useful to work around memory leaks in 3rd party libraries. For
; endless request processing specify '0'. Equivalent to PHP_FCGI_MAX_REQUESTS.
; Default Value: 0
pm.max_requests = 100

可運行 process = pm.max_children * pm.max_requests

外層如果有nginx
worker_connections 8192;
worker_processes auto;
可運行requset = 8192 * 核心數

* 每秒監控
while [ 1 ]; do ps aux | grep 'php-fpm: pool' | wc -l; sleep 1; echo '------'; done
