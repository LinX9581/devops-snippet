curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

curl -O https://nginx.org/download/nginx-1.16.1.tar.gz
tar xvzf nginx-1.16.1.tar.gz
git clone --recursive https://github.com/cloudflare/quiche
cd nginx-1.16.1
patch -p01 < ../quiche/extras/nginx/nginx-1.16.patch

apt-get install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev

./configure                          	\
   	--prefix=$PWD                       	\
   	--with-http_ssl_module              	\
   	--with-http_v2_module               	\
   	--with-http_v3_module               	\
   	--with-openssl=../quiche/deps/boringssl \
   	--with-quiche=../quiche
make

都不行 安裝 GO