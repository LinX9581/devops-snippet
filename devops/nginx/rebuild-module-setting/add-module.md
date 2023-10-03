nginx -v
1.14.2

wget https://nginx.org/download/nginx-1.14.2.tar.gz
tar -xzvf nginx-1.14.2.tar.gz
git clone https://github.com/perusio/nginx-hello-world-module.git

cd nginx-1.14.2/
./configure --with-compat --add-dynamic-module=../nginx-hello-world-module
make modules
sudo cp objs/ngx_http_hello_world_module.so /usr/lib/nginx/modules

寫入 nginx.conf
load_module modules/ngx_http_hello_world_module.so; 

nginx -t
```
nginx: [emerg] module "/usr/share/nginx/modules/ngx_http_naxsi_module.so" is not binary compatible in /etc/nginx/nginx.conf:2
nginx: configuration file /etc/nginx/nginx.conf test failed
```



apt install build-essential libpcre3-dev zlib1g-dev -y
wget https://nginx.org/download/nginx-1.18.0.tar.gz
tar zxvf nginx-1.18.0.tar.gz
git clone https://github.com/chobits/ngx_http_proxy_connect_module.git
git clone https://github.com/perusio/nginx-hello-world-module.git
cd nginx-1.18.0/
patch -p1 < ../ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_1018.patch
 ./configure --with-compat  --add-dynamic-module=../nginx-hello-world-module --add-dynamic-module=../ngx_http_proxy_connect_module  `nginx -V`
make modules
cp objs/ngx_http_hello_world_module.so /usr/lib/nginx/modules/
cp objs/ngx_http_proxy_connect_module.so /usr/lib/nginx/modules/

nano /etc/nginx/modules-enabled/hello_world.conf
load_module modules/ngx_http_hello_world_module.so;
nano /etc/nginx/modules-enabled/proxy_connect.conf
load_module modules/ngx_http_proxy_connect_module.so;