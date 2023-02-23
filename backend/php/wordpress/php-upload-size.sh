#! /bin/bash
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/g' /etc/php/7.4/fpm/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /etc/php/7.4/fpm/php.ini
sed -i 's/memory_limit = 64M/memory_limit = 128M/g' /etc/php/7.4/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/7.4/fpm/php.ini
sed -i 's/client_max_body_size 50m/client_max_body_size 128m/g' /etc/nginx/nginx.conf
sudo service nginx restart
sudo service php7.4-fpm restart