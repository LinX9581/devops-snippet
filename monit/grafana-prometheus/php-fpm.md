# 參考
https://blog.gtwang.org/linux/nginx-enable-php-fpm-status-page-tutorial/

nano etc/php/7.4/fpm/pool.d/www.conf
pm.status_path = /status
ping.path = /ping

server {
    listen 8080;
    location ~ ^/(status|ping)$ {
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    }
}