
# ref
https://github.com/knyar/nginx-lua-prometheus#known-issues
https://github.com/knyar/nginx-lua-prometheus
https://chenzhonzhou.github.io/2019/03/10/prometheus-jian-kong-nginx/

# install
apt install libnginx-mod-http-lua
chown lin /etc/nginx
cd /etc/nginx
wget https://github.com/knyar/nginx-lua-prometheus/archive/refs/tags/0.20220527.tar.gz
tar -xvf 0.20220527.tar.gz
mv nginx-lua-prometheus-0.20220527 nginx-lua-prometheus
rm -rf 0.20220527.tar.gz

nginx.conf

load_module /usr/share/nginx/modules/ndk_http_module.so;
load_module /usr/share/nginx/modules/ngx_http_lua_module.so;

http
	lua_shared_dict prometheus_metrics 10M;
	lua_package_path "/path/to/nginx-lua-prometheus/?.lua;;";

	init_worker_by_lua_block {
	prometheus = require("prometheus").init("prometheus_metrics")

	metric_requests = prometheus:counter(
		"nginx_http_requests_total", "Number of HTTP requests", {"host", "status"})
	metric_latency = prometheus:histogram(
		"nginx_http_request_duration_seconds", "HTTP request latency", {"host"})
	metric_connections = prometheus:gauge(
		"nginx_http_connections", "Number of HTTP connections", {"state"})
	}

	log_by_lua_block {
		metric_requests:inc(1, {ngx.var.server_name, ngx.var.status})
		metric_latency:observe(tonumber(ngx.var.request_time), {ngx.var.server_name})
	}


