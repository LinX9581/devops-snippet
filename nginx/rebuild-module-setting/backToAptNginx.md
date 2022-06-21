cp /sbin/nginx /nginx.bak #要把腳本裡面備份 改成nginx
/sbin/nginx -s stop
cp nginx /sbin/nginx 
/usr/sbin/nginx -c /etc/nginx/nginx.conf #要認的nginx設定檔的位置
再把原先編譯的nginx占用的port砍掉
sudo fuser -k 80/tcp
sudo fuser -k 443/tcp
service nginx restart