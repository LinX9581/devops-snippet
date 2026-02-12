#!/bin/bash

# 更新系統包
sudo apt update
sudo apt -y upgrade

# 安裝必要的依賴
sudo apt-get install -y build-essential libssl-dev
sudo apt install net-tools -y
sudo apt install nginx -y

# 設定時區
sudo timedatectl set-timezone Asia/Taipei

# 安裝 NVM (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# 設定 NVM 環境變量
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# 在 .bashrc 中加入 NVM 初始化命令
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc

# 安裝 Node.js
nvm install 22
nvm use 22
nvm alias default 22

# 全局安裝 npm 套件
npm install -g pm2 yarn nodemon
