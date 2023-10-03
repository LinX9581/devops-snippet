## 排程
```
定期刪除五天以前的檔案
40 1 * * * userxx /usr/bin/rm `date  --date="-5 day"  +\%Y-\%m-\%d`*.gz
日期運算另一種寫法 date -d "-1 day" +"%Y-%m-%d"

使用Nodejs的 cronjob
https://stackoverflow.com/questions/20643470/execute-a-command-line-binary-with-node-js

dump特定格式的sql檔
mysqldump -u developer -p7e9BurMrbt88JuIC dbtest > /var/www/db-backup-crojob/$(date '+%Y.%m.%d'-%H-%M).sql

調整時區
sudo dpkg-reconfigure tzdata
```