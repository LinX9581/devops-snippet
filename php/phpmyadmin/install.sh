# 更新 phpmyadmin
```
sudo mv /usr/share/phpmyadmin/ /usr/share/phpmyadmin.bak
wget www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip
unzip phpMyAdmin-latest-all-languages.zip
sudo mkdir /usr/share/phpmyadmin
sudo mv phpMyAdmin-*/* /usr/share/phpmyadmin/
sudo vim /usr/share/phpmyadmin/libraries/vendor_config.php
define('TEMP_DIR', '/var/lib/phpmyadmin/tmp/');
define('CONFIG_DIR', '/etc/phpmyadmin/');
```

建議改用docker
