各種exporter 下載
https://prometheus.io/download/

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
mkdir /process-exporter
cat>/process-exporter/config.yml<<EOF
process_names:
  - name: "{{.Comm}}"
    cmdline:
    - '.+'
EOF
docker run -itd -p 9256:9256 --privileged --name=process-exporter -v /proc:/host/proc -v /process-exporter/:/config ncabatoff/process-exporter --procfs /host/proc -config.path config/config.yml path config/config.yml
# node-exporter
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

# php-fpm-expoter
https://www.jianshu.com/p/eb0dc90a3753
grafana id 4912
docker run -it -p 9094:9253 -d -e PHP_FPM_SCRAPE_URI="http://172.16.2.10:8080/status,http://172.16.2.42:8080/status" hipages/php-fpm_exporter

wget https://github.com/bakins/php-fpm-exporter/releases/download/v0.6.1/php-fpm-exporter.linux.amd64 -O /usr/local/src/php-fpm-exporter
chmod +x  /usr/local/src/php-fpm-exporter

nohup /usr/local/src/php-fpm-exporter --addr 0.0.0.0:9190 --endpoint http://172.16.2.10:8080/status

docker-compose up -d