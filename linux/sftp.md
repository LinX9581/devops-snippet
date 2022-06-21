# sftp
sudo addgroup sftp
sudo useradd -m sftp_user -g sftp
sudo passwd sftp_user
sudo chmod 700 /home/sftp_user/
sudo nano /etc/ssh/sshd_config
* PasswordAuthentication -> yes
service ssh restart