各種exporter 下載
https://prometheus.io/download/

民間教學
https://chenzhonzhou.github.io/2019/03/04/prometheus-jian-kong-redis/

# 開機自動重啟
[Unit]
Description=nginx-prometheus-exporter
Documentation=https://github.com/nginxinc/nginx-prometheus-exporter
After=network.target

[Service]
Type=simple
User=root
ExecStart= /root/exporter/nginx-prometheus-exporter_0.10.0/nginx-prometheus-exporter \
-web.listen-address=:9113 \
-nginx.scrape-uri=http://127.0.0.1:81/metrics
Restart=on-failure

[Install]
WantedBy=multi-user.target

# mysql-exporter
https://www.jianshu.com/p/faac55bd0a5b
grafana id 7362

version: '2.1'
services:
   mysqld-exporter:
    image: prom/mysqld-exporter
    container_name: mysqld-exporter
    environment:
      - DATA_SOURCE_NAME=exporter:123456@(192.168.5.242:3306)/
    ports:
    -  "9104:9104"
    restart: "always"
    
docker-compose up -d

CREATE USER 'exporter'@'%' IDENTIFIED BY '123456';
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';
flush privileges;

確認 mysql-exporter 所在的VM能否連到資料庫
mysql -h 192.168.5.242 -u exporter -p 123456

* 不管連線成功或失敗 都會有數字 差在連線成功取得的參數非常非常多
curl 127.0.0.1:9104/metrics
也要確保 promethues 能 curl 127.0.0.1:9104/metrics

# process-exporter
grafana id = 13882
localhost
https://chenzhonzhou.github.io/2020/11/19/prometheus-process-exporter-jian-kong-fu-wu-jin-cheng/

* docker
mkdir /process-exporter
cat>/process-exporter/config.yml<<EOF
process_names:
  - name: "{{.Comm}}"
    cmdline:
    - '.+'
EOF
docker run -itd -p 9256:9256 --privileged --name=process-exporter -v /proc:/host/proc -v /process-exporter/:/config ncabatoff/process-exporter --procfs /host/proc -config.path config/config.yml path config/config.yml

* 非docker
wget https://github.com/ncabatoff/process-exporter/releases/download/v0.7.5/process-exporter-0.7.5.linux-amd64.tar.gz
tar xvfz process-exporter-0.7.5.linux-amd64.tar.gz
cat>./config.yml<<EOF
process_names:
  - name: "{{.Comm}}"
    cmdline:
    - '.+'
EOF
./process-exporter-0.7.5.linux-amd64/process-exporter -config.path=./config.yml &


# node-exporter
grafana id = 11074(主要) 1860 8919

docker run -d -p 9100:9100 \
-v "/proc:/host/proc" \
-v "/sys:/host/sys" \
-v "/:/rootfs" \
--name=gra_node-exporter \
prom/node-exporter \
--path.procfs /host/proc \
--path.sysfs /host/sys \
--collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"

wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz
cd node_exporter-1.3.1.linux-amd64
./node_exporter &

# cadvisor
https://hackmd.io/@Yihsuan/ByJeApsNS?type=view

docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --restart=always \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/google-containers/cadvisor:v0.36.0

# redis-exporter
https://www.glab.cc/archives/43/

version: '3.7'
services:
  redis-exporter:
    image: oliver006/redis_exporter
    container_name: redis_exporter
    entrypoint: ["/redis_exporter","-debug"]
    # redis有密码时
    # entrypoint: ["/redis_exporter","-debug", "-redis.user admin", "-redis.password xxxx"]
    hostname: redis_exporter
    restart: always
    ports:
        - "9121:9121"

# nginx-exporter
grafana id 12708

docker run -p 9113:9113 nginx/nginx-prometheus-exporter:0.10.0 -nginx.scrape-uri=http://<nginx>:8080/stub_status

# nginx-blackbox_exporter
https://github.com/prometheus/blackbox_exporter
https://tech-blog.jameshsu.csie.org/post/devops-prometheus-blackbox_exporter/
https://blog.csdn.net/ryanlll3/article/details/113829474
可監控狀態碼


mkdir /expoter/nginx -P
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.21.1/blackbox_exporter-0.21.1.linux-amd64.tar.gz
tar zxvf blackbox_exporter-0.21.1.linux-amd64.tar.gz
rm -rf blackbox_exporter-0.21.1.linux-amd64.tar.gz
mv blackbox_exporter-0.21.1.linux-amd64/ blackbox_exporter

nano /usr/lib/systemd/system/blackbox_exporter.service

[Unit]
Description=blackbox_exporter
Documentation=https://github.com/prometheus/blackbox_exporter
After=network.target

[Service]
User=root
Type=simple
ExecStart= /expoter/nginx/blackbox_exporter/blackbox_exporter \
--config.file=/expoter/nginx/blackbox_exporter/blackbox.yml \
Restart=on-failure

[Install]
WantedBy=multi-user.target

systemctl daemon-reload
systemctl start blackbox_exporter
systemctl enable blackbox_exporter

# php-fpm-expoter
https://www.jianshu.com/p/eb0dc90a3753
grafana id 4912
docker run -it -p 9094:9253 -d -e PHP_FPM_SCRAPE_URI="http://172.16.2.10:8080/status,http://172.16.2.42:8080/status" hipages/php-fpm_exporter

wget https://github.com/bakins/php-fpm-exporter/releases/download/v0.6.1/php-fpm-exporter.linux.amd64 -O /usr/local/src/php-fpm-exporter
chmod +x  /usr/local/src/php-fpm-exporter

nohup /usr/local/src/php-fpm-exporter --addr 0.0.0.0:9190 --endpoint http://172.16.2.10:8080/status

docker-compose up -d