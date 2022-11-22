
d=test v=detail f=force
測試
logrotate -d -f /etc/logrotate.d/nginx

強制
logrotate -vf /etc/logrotate.d/nginx

nano /etc/logrotate.d/nginx
/usr/local/nginx/logs/*.log {
    # 指定转储周期为每天
    daily
    # 使用当期日期作为命名格式
    dateext
    # 如果日志丢失，不报错继续滚动下一个日志
    missingok
    # 保留 31 个备份
    rotate 31
    # 不压缩
    nocompress
    # 整个日志组运行一次的脚本
    sharedscripts
    # 转储以后需要执行的命令
    postrotate
        # 重新打开日志文件
        [ ! -f /usr/local/nginx/nginx.pid ] || kill -USR1 `cat /usr/local/nginx/nginx.pid`
    endscript
}


default
/var/log/nginx/*.log {
	daily
	missingok
	rotate 7
	compress
	delaycompress
	notifempty
	create 0640 www-data adm
	sharedscripts
	prerotate
		if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
			run-parts /etc/logrotate.d/httpd-prerotate; \
		fi \
	endscript
	postrotate
		invoke-rc.d nginx rotate >/dev/null 2>&1
	endscript
}



