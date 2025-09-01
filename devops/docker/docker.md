docker ps：檢視容器列表(不含停止運行的容器)
docker ps -a：檢視所有容器列表
docker rm：移除容器 -f 強制移除
docker images：檢視映像檔列表
docker rmi：移除映像檔
docker run：執行容器
docker stop：暫停容器
docker start：恢復容器
docker inspect：檢視容器詳細資訊
docker logs --details 3e2 : 檢視容器log --follow
docker exec -it id bash : 連到特定container /bin/bash /bin/sh
docker network inspect bridge : 查看container走哪個IP
docker-compose up -d : 啟用dockerfile
docker rename open_ovpn_1 gra_open_ovpn_1
ping -c 2 172.17.0.3 : ping
docker update --restart=always ID : 讓container重開機自動重啟
docker search ubuntu -f is-official=true : 搜尋官方Image
docker logs ID --tail 10
# GUI Docker Portainer
docker run -d -p 4000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /var/Portainer:/data portainer/portainer

# 自架 Docker registry
docker run -d -p 3006:5000 -v /docker/registry:/var/lib/registry --name registry registry:2
* ip 為 vm 本身的內部IP
cat>/etc/docker/daemon.json<<EOF
{ "insecure-registries":["172.16.97.6:3006"] }
EOF
docker tag node-test 172.16.97.6:3006/node-test
docker push 172.16.97.6:3006/node-test
docker pull 172.16.97.6:3006/node-test

curl -X GET http://172.16.97.6:3006/v2/_catalog
curl -X GET http://172.16.97.6:3006/v2/mytomcat/tags/list

# 刪除特定字串的 docker images 只保留最新的三個
docker images --format "table {{.Repository}}:{{.Tag}}\t{{.CreatedAt}}" | \
  grep "stg-fn-servlet/stg-fn-servlet" | \
  tail -n +4 | \
  awk '{print $1}' | \
  xargs -r docker rmi

* 特定字串不保留 全刪除
docker images --format "{{.Repository}}:{{.Tag}}" | \
  grep "stg-bn-news/stg-bn-news" | \
  xargs -r docker rmi

# mount 
file to file
docker run -itd -v ./config.js:/usr/src/app/config.js --name node-template -p 3008:3008 node-template

# transfer
docker cp mycontainer:/opt/testnew/file.txt /opt/test/
docker cp /opt/test/file.txt mycontainer:/opt/testnew/

# build
docker build -t node-test . --no-cache
docker run  --name node-test -p 3000:3000 -it node-test

# phpmyadmin docker
註解IP
nano /etc/mysql/mariadb.conf.d/50-server.cnf

新增使用者
CREATE USER 'db'@'172.17.0.2' IDENTIFIED BY '00000000';
GRANT ALL PRIVILEGES ON *.* TO 'db'@'172.17.0.2' IDENTIFIED BY '00000000' WITH GRANT OPTION;
FLUSH PRIVILEGES;

nginx 
# phpmyadmin only nn ip
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;

    ssl_certificate /etc/nginx/ssl/linx-website.crt;
    ssl_certificate_key /etc/nginx/ssl/linx-website.key;
    access_log /var/log/nginx/admin.linx.website_ssl-access.log main;
    error_log /var/log/nginx/admin.linx.website_ssl-error.log;
    server_name admin.linx.website;

    # include /etc/nginx/sites-enabled/cf.conf;
    real_ip_header X-Forwarded-For;
	location / {
		proxy_pass http://127.0.0.1:8283;
		proxy_http_version 1.1;
		proxy_set_header Host $host;
	}
}