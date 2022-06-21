#!/bin/bash
#
# This script configures WordPress file permissions based on recommendations
# from http://codex.wordpress.org/Hardening_WordPress#File_permissions
#
# 原作: Michael Conigliaro <mike [at] conigliaro [dot] org> 本地化： Chun
#
WP_OWNER=www-data # <-- 這裡輸入伺服器上的角色名稱
WP_GROUP=www-data # <-- 伺服器設定的角色群組（通常都是同上）
WP_ROOT=$1 # <-- WordPress 的根目錄
WS_GROUP=www-data # <-- 如有要改變設定與內容目錄權限群組可以設定這裡，通常不變

# 先處理重置基礎權限部分
find ${WP_ROOT} -exec chown ${WP_OWNER}:${WP_GROUP} {} \;
find ${WP_ROOT} -type d -exec chmod 755 {} \;
find ${WP_ROOT} -type f -exec chmod 644 {} \;

# 改變 wp-config.php 設定檔案的操作權限（如果有的話）
chgrp ${WS_GROUP} ${WP_ROOT}/wp-config.php
chmod 660 ${WP_ROOT}/wp-config.php

# 改變 wp-content 內容目錄的操作權限（如果有的話）
find ${WP_ROOT}/wp-content -exec chgrp ${WS_GROUP} {} \;
find ${WP_ROOT}/wp-content -type d -exec chmod 775 {} \;
find ${WP_ROOT}/wp-content -type f -exec chmod 664 {} \;