Ex old.com  = >  new.com
# WordPress migration

1. 檔案轉移
移動整包wordpress
mv A wordpress to B /var/www/Awordpress

2. 資料庫轉移
從 old 匯出 sql
mysqldump -u root -p old > /home/lin/old.sql

匯入 sql 到 new
mysql -u developer -p new < /home/lin/new.sql

3. 修改資料庫
在資料庫把 https://old.com 取代成https://new.com

UPDATE wp_posts
SET post_content = REPLACE(post_content, 'https://old.com', 'https://new.com')
WHERE post_content LIKE '%https://old.com%';

UPDATE wp_posts
SET guid= REPLACE(guid, 'https://old.com', 'https://new.com')
WHERE guid LIKE '%https://old.com%';

UPDATE wp_options
SET option_value = REPLACE(option_value, 'https://old.com', 'https://new.com')
WHERE option_value LIKE '%https://old.com%';

4. 修改設定檔 wp-config.php
wp-config.php 加這兩行才能可以導到 new.com
define('WP_SITEURL', 'https://new.com');
define('WP_HOME', 'http://new.com');

5. chown www-data: game.linx.services/ -R
# 常見問題
1. 帳密忘記
更新admin使用者 密碼為 md5('admin')
UPDATE wp_users SET user_pass = '21232f297a57a5a743894a0e4a801fc3' WHERE user_login = 'lin@new.com';

如果忘記使用者名稱 先進到資料庫的 database
select * from wp_users;

2. 如果只是建測試站 但後台網址有特別變過
UPDATE wp_options
SET option_value = REPLACE(option_value, 'https://old.com', 'https://new.com')
WHERE option_name = 'home' OR option_name = 'siteurl';

3. 裝外掛被問需要 FTP 
sudo chown -R www-data:www-data /var/www/wordpress/wp-content/
再不行 就在wp-config.php增加
define('FS_METHOD', 'direct');

4. Wp-json 啟用
設定-固定連結-只要不要用預設網址就能啟用

5. 圖片連結
select * from wp_postmeta WHERE meta_value LIKE '%https://game.linx.services/wp-content/uploads/2021/08/cf8502c3-2021051141703400-500x326.jpg%' order by meta_id DESC limit 20;

select * from wp_posts WHERE post_content LIKE '%https://game.linx.services/wp-content/uploads/2021/08/cf8502c3-2021051141703400-500x326.jpg%';

6. 內文
wp-includes/media.php:1269 -> image_baseurl 指定往 gcs

7. banner
wp-includes/post.php:5884 -> url 指定往 gcs