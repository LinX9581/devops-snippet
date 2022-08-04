#! /bin/bash
sudo apt update
sudo apt -y upgrade
sudo apt update
sudo timedatectl set-timezone Asia/Taipei

# stackdriver
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# nodejs
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt -y install nodejs
npm i nodemon pm2 yarn -g
sudo pm2 startup
apt install git -y

apt install nginx -y
sudo systemctl enable nginx
chown lin /etc/nginx/sites-enabled/default

# debian 安裝方式會不一樣
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
# docker run --restart=on-failure:3 --name="phpMyAdmin-local" -itd -e PMA_HOST=$(ip route show | grep docker0 | awk '{print $9}') -p 8283:80 phpmyadmin/phpmyadmin
# docker run -d -p 4000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /var/Portainer:/data portainer/portainer

# ubuntu
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu `lsb_release -cs` test"
sudo apt update
sudo apt install docker-ce -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)"  -o /usr/local/bin/docker-compose
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
systemctl enable docker.service