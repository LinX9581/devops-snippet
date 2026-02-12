#!/bin/bash

# Tomcat 安全設定腳本

# 創建 tomcat 使用者和群組（如果不存在）
if ! getent group tomcat > /dev/null; then
    sudo groupadd -r tomcat
    echo "創建 tomcat 群組"
fi

if ! getent passwd tomcat > /dev/null; then
    sudo useradd -r -g tomcat -d /opt/tomcat -s /bin/false tomcat
    echo "創建 tomcat 使用者"
fi

# 設定權限和擁有者
sudo chown tomcat:tomcat /opt/tomcat
sudo chown tomcat:tomcat /opt/tomcat/conf
sudo chmod o-rwx /opt/tomcat/logs
sudo chown tomcat:tomcat /opt/tomcat/bin
sudo chown tomcat:tomcat /opt/tomcat/webapps
sudo chmod g-w,o-rwx /opt/tomcat/webapps
sudo chmod 600 /opt/tomcat/conf/catalina.policy
sudo chown tomcat:tomcat /opt/tomcat/conf/logging.properties
sudo chmod 600 /opt/tomcat/conf/logging.properties

echo "Tomcat 安全設定完成" 