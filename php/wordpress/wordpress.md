# webinoly
第三方客製化產生wordpress

# wnmp
手動每個環境都安裝wordpress
https://alibaba-cloud.medium.com/setting-up-a-server-cluster-for-enterprise-web-apps-part-2-58429e4b92de

# Wordpress 相關問題

## Wordpress上Git
```
一般會濾掉備份檔 和 媒體庫 和 快取
tar cvf bobee.tar --exclude=bobee.linx.services/wp-content/uploads --exclude=bobee.linx.services/wp-content/uploads2 bobee.linx.services

.gitignore 也需要濾掉
wp-content/uploads
wp-content/uploads2
wp-content/cache
wp-content/ai1wm-backups
*.txt
```
## Wordpress 搬家
```
1.搬家如果網址會更換
需要在 wp-config.php增加
define('WP_SITEURL', 'https://domain.com');
define('WP_HOME', 'http://domain.com');

2. root密碼不見
設定的密碼必須是MD5格式
UPDATE wp_users SET user_pass = '21232f297a57a5a743894a0e4a801fc3' WHERE user_login = 'admin';

3.啟用 Wp-json
設定-固定連結-只要不要用預設網址就能啟用

4. 外掛需要FTP權限
sudo chown -R www-data:www-data /var/www/wordpress/wp-content/
再不行 就在wp-config.php增加
define('FS_METHOD', 'direct');


```
## 分頁404
```
    location / {
                # This is cool because no php is touched for static content.
                # include the "?$args" part so non-default permalinks doesn't break when using query string
                try_files $uri $uri/ /index.php?$is_args$args =404;
    }


    if (!-e $request_filename) {
            rewrite ^.*$ /index.php last;
    }
```

## WordPress 常用SQL
[參考](https://www.seeksunslowly.com/clean-wordpress-mysql-wp_posts-data-sc)
* 查看未發佈文章數
```
SELECT * FROM wp_posts WHERE 'post_status' <> 'publish';
```
* 查看文章的發佈狀態數
```
SELECT post_status , count(1)
  FROM wp_posts
 WHERE 'post_status' <> 'publish'
 GROUP BY 'post_status';
```
* 刪除inherit 文章
```
DELETE FROM wp_posts
 WHERE post_status = 'inherit';

```
* 刪除草稿
```
DELETE FROM wp_posts WHERE post_status != 'publish' OR post_type='revision';
```
* 刪除五年以外文章
```
DELETE FROM wp_posts WHERE DATEDIFF(NOW(), `post_date`) > 1825;
```
* 查詢大於五年的文章數
```
SELECT post_date,count(1) FROM wp_posts WHERE DATEDIFF(NOW(), `post_date`) > 1825;
```

* 運行中的 Proccess
[參考](https://www.centos.bz/2017/08/mysql-show-processlist-intro/)
```
mysqladmin processlist;
show processlist;
```
* 只查看特定commond的Process
```
select id, db, user, host, command, time, state, info
from information_schema.processlist
where command = 'Query'
order by time desc;
```

* 撈特定User 執行的Query
```
Select concat('KILL ',id,';') from information_schema.processlist where user='user';
```
* 超過兩分鐘 非sleep 的 process
```
select concat('kill ', id, ';')
from information_schema.processlist
where command != 'Sleep'
and time > 2*60
order by time desc 
```
* 關閉所有外掛
```
UPDATE wp_options SET option_value = 'a:0:{}' WHERE option_name = 'active_plugins';
```

* 全域regex replace
```
UPDATE petsmao.post_pv_count SET post_id = REGEXP_REPLACE(`post_id`,'[0-9]{8}-','')
```
