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

//找出當前thread數  平均落在 300
netstat -nat | grep 80 | wc -l

//找出所有process數 平均落在 200
ps -eLf | grep java | wc -l

// 參數介紹
https://www.itread01.com/content/1545137663.html

https://www.gushiciku.cn/pl/gaXZ/zh-tw

伺服器中可以同時接收的連線數為maxConnections+acceptCount