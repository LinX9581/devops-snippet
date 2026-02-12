

網頁的資料都放在 gcs 的情況 壓測環境如下
{ duration: "30s", target: 355 },  
{ duration: "2m", target: 555 }, 


1. 只有調整 nginx
http_req_duration..............: avg=5.66s  min=157.16ms med=4.91s  max=13.27s p(90)=11.32s p(95)=12.19s

2. 調整 php-fpm
sudo sed -i 's|;listen.backlog = 511|listen.backlog = 2048|' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm = .*/pm = dynamic/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.max_children = .*/pm.max_children = 60/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.start_servers = .*/pm.start_servers = 15/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.min_spare_servers = .*/pm.min_spare_servers = 10/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.max_spare_servers = .*/pm.max_spare_servers = 25/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^;pm.max_requests = .*/pm.max_requests = 500/' /etc/php/8.4/fpm/pool.d/www.conf
sudo sed -i 's/^pm.max_requests = .*/pm.max_requests = 500/' /etc/php/8.4/fpm/pool.d/www.conf

http_req_duration..............: avg=7.49s  min=164.3ms med=8.15s  max=15.72s p(90)=14.39s p(95)=14.94s

3. 調整內核參數 /etc/sysctl.conf
http_req_duration..............: avg=8.24s  min=166.37ms med=8.99s  max=16.51s p(90)=15.3s p(95)=15.79s