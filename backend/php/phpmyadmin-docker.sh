#! /bin/bash
# 預設是連 127.0.0.1:3306
# local的資料庫要建立使用者允許 phpmyadmin的IP
export os=ubuntu    # debian

if [ $os = "debian" ]
then
    sudo apt update
    sudo apt -y upgrade
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt update
    apt-cache policy docker-ce
    sudo apt install docker-ce -y
    sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
    sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
    chmod +x /usr/bin/docker-compose
    systemctl enable docker.service
else
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` test"
    sudo apt update
    sudo apt install docker-ce -y
    sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
    sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
    chmod +x /usr/bin/docker-compose
    systemctl enable docker.service
fi
docker run --name="phpMyAdmin-local" -itd -e PMA_HOST=$(ip route show | grep docker0 | awk '{print $9}') -p 8283:80 phpmyadmin/phpmyadmin