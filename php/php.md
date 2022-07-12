# php 參數顯示
grep -v ";" /etc/php/7.4/fpm/pool.d/www.conf | grep -Ev "^$"

最佳配置網站計算
https://cmorrell.com/php-fpm/
https://mini.nidbox.com/diary/read/9924593
https://cloud.tencent.com/developer/article/1114676

# php timeout 相關
http://blog.jcr.pub/2020/06/22/resolve-php-method-timeout/
nginx 
fastcgi_connect_timeout 600s;
fastcgi_send_timeout 600s;
fastcgi_read_timeout 600s;
keepalive_timeout

php.ini
max_execution_time = 600
max_input_time = 600

# 通訊方式
unix socket
效率高
/etc/php/7.4/fpm/pool.d/www.conf

```
location ~ \.php$ {

include fastcgi_params;

fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;;

fastcgi_pass unix:/var/run/php5-fpm.sock;

fastcgi_index index.php;

}
```

tcp socket
windows 只能走tcp
php nginx不同台時的連線方式
```
location ~ \.php$ {

include fastcgi_params;

fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;;

fastcgi_pass 127.0.0.1:9000;

fastcgi_index index.php;

}
```

# 上傳大小
(https://blog.gtwang.org/wordpress/how-to-increase-the-maximum-file-upload-size-in-wordpress/)
修改單一檔案大小上限：
upload_max_filesize = 16M
修改 POST 資料大小上限：
post_max_size = 32M
修改記憶體上限
memory_limit = 64M
修改執行時間上限（單位為秒）：
max_execution_time = 300

nginx
http {
  client_max_body_size 32m;
}
sudo service nginx restart

# 搜尋取代 檔案大小
#! /bin/bash
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 128M/g' /etc/php/7.4/fpm/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /etc/php/7.4/fpm/php.ini
sed -i 's/memory_limit = 64M/memory_limit = 128M/g' /etc/php/7.4/fpm/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /etc/php/7.4/fpm/php.ini
sed -i 's/client_max_body_size 50m/client_max_body_size 128m/g' /etc/nginx/nginx.conf
sudo service nginx restart
sudo service php7.4-fpm restart

# 版本切換

* 如果裝多個版本的php 可用下面指令切換
sudo update-alternatives --set php /usr/bin/php7.4

* 版本共存 for debian ubuntu
[參考](https://xenby.com/b/175-%E6%95%99%E5%AD%B8-%E5%9C%A8ubuntu%E5%AE%89%E8%A3%9D%E5%A4%9A%E7%89%88%E6%9C%ACphp-nginx)
```
裝完各版本PHP
改完各版本的 /etc/php/7.2/fpm/php.ini
改 ;cgi.fix_pathinfo=1
成 cgi.fix_pathinfo=0
改nginx php7.4-fpm.sock 分別對應

```

# composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

cd /var/www/html
sudo composer create-project laravel/laravel MyProject --prefer-dist

sudo chown -R www-data:www-data /var/www/html/MyProject/
sudo chmod -R 755 /var/www/html/MyProject/

# 分頁 404
    location / {
                # This is cool because no php is touched for static content.
                # include the "?$args" part so non-default permalinks doesn't break when using query string
                try_files $uri $uri/ /index.php?$is_args$args =404;
    }


    if (!-e $request_filename) {
            rewrite ^.*$ /index.php last;
    }