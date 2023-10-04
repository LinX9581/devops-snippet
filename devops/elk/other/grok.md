112.121.121.5 0.064 - - [21/Nov/2021:06:25:34 +0800]
$remote_addr - $remote_user [$time_local]
%{IPORHOST:[nginx][access][remote_ip]} - %{DATA:[nginx][access][user_name]} \[%{HTTPDATE:[nginx][access][time]}\]

$upstream_response_time
0.064
%{BASE16FLOAT:[nginx][access][upstream_response_time]}

$http_host
www.linxnote.club
%{IPORHOST:[nginx][access][http_host]}

"GET /cat/entertainment/star/ HTTP/1.1"
"$request"
\"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\"

200
$status
%{NUMBER:[nginx][access][response_code]}

612
$body_bytes_sent
%{NUMBER:[nginx][access][body_sent][bytes]}

"-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246" "13.56.1.1"
'$http_referer $http_user_agent $http_x_forwarded_for'
\"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\"


105.213.105.136 - - [23/Nov/2021:15:59:39 +0800] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36" "-"
%{IPORHOST:[nginx][access][remote_ip]} - %{DATA:[nginx][access][user_name]} \[%{HTTPDATE:[nginx][access][time]}\] \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\"


# www
112.121.121.5 0.064 - [21/Nov/2021:06:25:34 +0800] www.linxnote.club "GET /cat/entertainment/star/ HTTP/1.1" 200 25819 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246" "13.56.1.1"

%{IPORHOST:[nginx][access][remote_ip]} %{DATA:[nginx][access][user_name]} %{DATA:[nginx][access][user_name]} \[%{HTTPDATE:[nginx][access][time]}\] %{IPORHOST:[nginx][access][http_host]} \"%{WORD:[nginx][access][method]} %{DATA:[nginx][access][url]} HTTP/%{NUMBER:[nginx][access][http_version]}\" %{NUMBER:[nginx][access][response_code]} %{NUMBER:[nginx][access][body_sent][bytes]} \"%{DATA:[nginx][access][referrer]}\" \"%{DATA:[nginx][access][agent]}\" \"%{DATA:[nginx][access][x_forwarded_for]}\"


'$remote_addr $upstream_response_time $upstream_cache_status [$time_local] '
	'$http_host "$request" $status $body_bytes_sent '
	'"$http_referer" "$http_user_agent" "$http_x_forwarded_for"';

'$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

112.121.121.5 - - [17/Mar/2022:08:12:24 +0800] www.linxnote.club "GET /favicon.ico HTTP/1.1" 404 1470 "https://www.linxnote.club/news/5746997?from=nnfb_p&utm_source=fb&utm_medium=nn&utm_campaign=p" "Mozilla/5.0 (Linux; Android 9; EVR-L29 Build/HUAWEIEVR-L29; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/98.0.4758.101 Mobile Safari/537.36 [FBIA/FB4A;FBAV/326.0.0.34.120;]" "42.77.30.186"

112.121.121.5 0.064 - [21/Nov/2021:06:25:34 +0800] www.linxnote.club "GET /cat/entertainment/star/ HTTP/1.1" 200 25819 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246" "13.56.1.1"


