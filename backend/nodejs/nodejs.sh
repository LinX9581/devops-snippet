#! /bin/bash
sudo apt update
sudo apt-get install -y build-essential libssl-dev
sudo apt -y upgrade
sudo timedatectl set-timezone Asia/Taipei
sudo apt update
apt install net-tools -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads 

nvm install 18
nvm use 18
nvm alias default 18

npm i pm2 yarn nodemon -g
apt install nginx -y