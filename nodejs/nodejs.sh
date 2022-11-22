#! /bin/bash
sudo apt update
sudo apt -y upgrade
sudo timedatectl set-timezone Asia/Taipei
sudo apt update
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
nvm install 16
nvm use 16
apt-get install nginx redis-server git mysql-server -y
sudo systemctl enable nginx mariadb
npm i pm2 yarn nodemon -g