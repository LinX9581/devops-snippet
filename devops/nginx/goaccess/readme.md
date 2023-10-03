log_format main '$remote_addr $upstream_response_time $upstream_cache_status [$time_local] '
        '$http_host "$request" $status $body_bytes_sent '
        '"$http_referer" "$http_user_agent" "$http_x_forwarded_for"';
        
goaccess -f /var/www/access.log.3 --log-format='%^ %^ %^ [%d:%t %^] %^ "%r" %s %b "%R" "%u" "%h"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S' -d -a > /var/www/html/log.html



--log-format='%^ %^ %^ [%d:%t %^] %^ "%r" %s %b "%R" "%u" "%h"'


pv stage
log_format  main  '$http_x_forwarded_for - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$remote_addr"';

goaccess -f /var/log/nginx/linxnote.club-access.log --log-format='%h %^[%d:%t %^] "%r" %s %b "%R" "%u" "%^"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S' -d -a > /var/www/html/log1.html

四方、CP
log_format we_log '$remote_addr $upstream_response_time $upstream_cache_status [$time_local] '
        '$http_host "$request" $status $body_bytes_sent $request_time '
        '"$http_referer" "$http_user_agent"';

log_format we_log '$http_x_forwarded_for $upstream_response_time $upstream_cache_status [$time_local] '
	'$http_host "$request" $status $body_bytes_sent $request_time '
	'"$http_referer" "$http_user_agent"';

goaccess -f /log/4way.log --log-format='%h %^ %^ [%d:%t %^] %^ "%r" %s %b %^ "%R" "%u"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S' -d -a > /var/www/html/4way.html
goaccess -f /var/www/cp.log --log-format='%h,%^,%^ %^ %^[%d:%t %^] %^ "%r" %s %b %^ "%R" "%u"' --date-format='%d/%b/%Y' --time-format='%H:%M:%S' -d -a > /var/www/html/cp.html

35.205.205.242, 112.121.121.5, 34.117.144.18 18.521 - [21/Jan/2022:00:00:13 +0800] linxnote.club "GET / HTTP/1.1" 200 65024 18.519 "-" "GoogleStackdriverMonitoring-UptimeChecks(https://cloud.google.com/monitoring)"