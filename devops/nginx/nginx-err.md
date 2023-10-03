* 部分系統會有Nginx剛裝完就跑不動，原因是Apache卡port
* 解決方式 先停用Apache 和 完整刪除Nginx
```
1. sudo systemctl stop apache2.service
2. sudo systemctl disable apache2.service
3. sudo apt-get --purge remove nginx -y
4. sudo apt-get autoremove -y
5. dpkg --get-selections|grep nginx
6. sudo apt-get --purge remove nginx
7. sudo apt-get --purge remove nginx-common -y
8. sudo apt-get --purge remove nginx-core -y

* sudo fuser -k 80/tcp // 刪除80Port的Proccess指令

9. apt-get install nginx -y

10. sudo systemctl start nginx
11. nginx 設定檔 ( 註一 ) 寫入 /etc/nginx/sites-enabled/default

```



## 自己編譯的nginx
* 先找執行檔在哪
find / -name "nginx"

sudo /etc/nginx/sbin/nginx    # 启动 Nginx 服务
sudo /etc/nginx/sbin/nginx -s stop   # 停止 Nginx 服务
sudo /etc/nginx/sbin/nginx -s reload # 重新加载 Nginx 配置文件