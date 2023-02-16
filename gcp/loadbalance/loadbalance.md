# GCP LB 有多種設置方式
http https tcp 

https://cloud.google.com/load-balancing/docs/https/https-logging-monitoring

# 讓nginx 取得 真實IP的設定方式
https://geko.cloud/en/forward-real-ip-to-a-nginx-behind-a-gcp-load-balancer/

set_real_ip_from 34.117.222.15;    # GCP LB Public ip
set_real_ip_from 112.121.121.0/24; # CDN
set_real_ip_from 35.0.0.0/8;       # GCP LB Privar IP
set_real_ip_from 130.0.0.0/8;      # GCP LB Privar IP
real_ip_header  X-Forwarded-For;
real_ip_recursive on;
deny 61.216.80.0/24;

此時的 remote addr 的 IP 才會是真實IP

實際上 VM有綁LB防火牆只要允許
130.211.0.0/22
35.191.0.0/16

gcp 防火牆走 Armor