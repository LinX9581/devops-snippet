# 測試結果

# 8C32G * 1
調整資料庫 
3m 3500 fail 3.65% AVG 6.19 P90 9.47 P95 10.62
3m 3500 fail 1.72% AVG 6.27 P90 8.49 P95 9.43
3m 3500 fail 1.61% AVG 6.06 P90 8.36 P95 9.24
3m 3500 fail 1.17% AVG 6.17 P90 9.84 P95 10.24
3m 3000 fail 2.56% AVG 5.35 P90 8.11 P95 9.49

# 16c64g * 1
30s 6000 (O) fail 8%  avg 5.62 p90 11.64s
30s 4000 (O) fail 10% avg 3.2  p95 8.49s
30s 3000 (O) fail 0.8% avg 3.13  p95 6~8.11s
30s 2000 (O) fail 0.0% avg 1.59  p95 4.83s
30s 1500 (O) fail 0.0% avg 1.05  p95 2.54s

# 8C32G * 2
proxy_connect_timeout 180;
proxy_read_timeout 180;
proxy_send_timeout 180;1
10S 8000 for 5m -> fail 17.26% AVG 6.63 ,P90 11.61 , p95 12.68
* 拔掉nginx proxy timeout
10S 8000 for 5m -> fail 7.87%  AVG 7.29 ,P90 11.74 , p95 12.77
10S 8000 for 5m -> fail 7.34%  AVG 7.29 ,P90 11.74 , p95 12.77

* nginx lb + least_conn
3m 7000 fail 0.06%  AVG 6.32 ,P90 10.36 , p95 11.36
* 沒有加 least_conn
3m 7000 fail 0.10%  AVG 5.86 ,P90 10.39 , p95 11.39

# 8C32G * 4
10S 8000 for 5m -> fail 5.86%  AVG 3.27 ,P90 9.92 , p95 11.37

# 8C32G * 5
30s 3500 30s/+200 -> 3500 fail 0.99 P95% 1.95
30s 5000 30s/+200 -> 5800 fail 1.31 P95% 2.95
30s 6000 30s/+200 -> 6800 fail 3.49 P95% 3.03
30s 7000 30s/+200 -> 7800 fail 16.14 P95% 4.13

# 8C32G * 6 
30M, 6000,  fail 19.28%  ,AVG 2.62S , P90 5.69, P95 7.91
30M, 8000,  fail 37.22%  ,AVG 3.04S , P90 8.00, P95 11.88
* php 減肥 , nginx lb least_conn , fpm timeout
3 M, 9000,  fail 7.65% ,AVG 1.95S, P90 3.48 P95 4.81
3 M, 10000, fail 9.90% ,AVG 2.27S, P90 3.99 P95 5.3
3 M, 12000, fail 9.86% ,AVG 2.85S, P90 5.39 P95 8.11
16M, 9000,  fail 7.59% ,AVG 2.22S, P90 3.93 P95 5.35
15M, 12000, fail 37.2% ,AVG 2.25S, P90 4.78 P95 6.72

* mysql 4C16G -> 8C16G  ,  sysctl -w net.ipv4.tcp_fin_timeout=15 , sysctl -w net.ipv4.tcp_tw_reuse=1
04M, 10000, fail 0.00% ,AVG 1.29S, P90 2.21 P95 2.26
04M, 12000, fail 0.00% ,AVG 1.84S, P90 3.18 P95 4.07
16M, 15000, fail 0.24% ,AVG 2.75S, P90 5.03 P95 5.88

# 8C32G * 9
30S, 5000,  fail 0.2%  ,AVG 1.9S , P95 4.9S
30S, 5000,  fail 0.09% ,AVG 3.13S, P95 15.49
30S, 5000,  fail 0.02% ,AVG 1.01S, P95 2.29
30S, 5000,  fail 0.17% ,AVG 0.86S, P90 1.82 P95 2.87
30S, 7000,  fail 0.27% ,AVG 1.37S, P95 7.13
30S, 7000,  fail 0.25% ,AVG 1.37S, P95 4.94
30S, 8500,  fail 0.00% ,AVG 1.33S, P90 3.53 P95 7.2
30S, 9500,  fail 0.00% ,AVG 1.66S, P90 3.71 P95 7.69
30S, 10000, fail 0.00% ,AVG 1.78S, P90 3.85 P95 7.79
30S, 10000, fail 1.67% ,AVG 5.04S, P90 16.13 P95 31.03
60S, 10000, fail 1.33% ,AVG 3.44S, P90 8.19 P95 16.42
30S, 11000, fail 0.00% ,AVG 1.97S, P90 5.61 P95 7.81
60S, 11000, fail 0.08% ,AVG 1.88S, P90 3.72 P95 7.75
* 資料庫設了 max_connect_errors = 10000 (避免mysql誤鎖連線過多的VM)
30S, 12000, fail 0.00% ,AVG 0.70S, P90 1.36 P95 2.78
30S, 13000, fail 0.00% ,AVG 1.45S, P90 4.57 P95 7.31
3 M, 11000, fail 5.80% ,AVG 0.74S, P90 1.93 P95 2.93
3 M, 13000, fail 13.2% ,AVG 0.94S, P90 2.23 P95 2.74
10M, 10000, fail 26.7% ,AVG 1.05S, P90 2.39 P95 3.27
* fpm -> 4000
同上
* 更改 tcp_fin_timeout = 15 , reuse = 1
10M, 12000, fail 29.65% ,AVG 1.63S, P90 3.22 P95 4.76

# Gcp Lb 8C32G * 9 fpm 4000
30S, 13000, fail 0.00% ,AVG 1.17S, P90 3.30 P95 4.2
30S, 15000, fail 6.11% ,AVG 2.77S, P90 3.53 P95 30
10M, 12000, fail 32.54% ,AVG 1.06S, P90 2.26 P95 3.03
# Gcp Lb 8C32G * 15 fpm 4000
30S, 13000, fail 4.99% ,AVG 1.77S, P90 3.87 P95 7.28
10M, 12000, fail 20.87% ,AVG 1.37S, P90 4.57 P95 6.76

