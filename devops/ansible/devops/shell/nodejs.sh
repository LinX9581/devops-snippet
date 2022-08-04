#! /bin/bash
sudo apt update
sudo apt -y upgrade
sudo timedatectl set-timezone Asia/Taipei
sudo apt update
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt -y install nodejs 
apt-get install nginx redis-server git mariadb-server mariadb-client -y
sudo systemctl enable nginx mariadb
npm i pm2 yarn nodemon -g