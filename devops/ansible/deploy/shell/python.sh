#! /bin/bash
sudo apt update
sudo timedatectl set-timezone Asia/Taipei
sudo apt install wget net-tools -y
sudo chmod -x /etc/update-motd.d/*
sudo apt install python3 python3-dev python3-pip -y
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
sudo apt install python3-venv -y

