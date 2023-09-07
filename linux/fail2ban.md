
* 查看 sshd 封鎖狀態
sudo fail2ban-client status sshd

* 查看防火牆狀態
sudo iptables -L -n

* 解鎖 IP
sudo fail2ban-client set sshd unbanip ip

* 重啟 fail2ban
sudo systemctl restart fail2ban

* 預設 ssh port 如何更改 設定檔也要跟改
/etc/fail2ban/jail.conf -> [sshd] port = 更改後的port

* 連線方式
ssh -p 23 test@35.229.190.68