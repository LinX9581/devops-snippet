apt install wget -y
sudo apt-get install nfs-kernel-server -y
systemctl start rpcbind nfs-server 
systemctl enable rpcbind nfs-server