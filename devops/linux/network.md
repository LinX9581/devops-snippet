## openVPN架設
```
https://ellis-wu.github.io/2017/03/31/openvpn-installation/
```


## 查看網站路由
traceroute www.google.com
dig www.google.com

https://www.whatsmydns.net/
可以查 root domain 目前 name server 狀況

## local firewall
1. 查看目前防火牆規則
iptables -L -n 
2. 接受所有IP 訪問 80 port
iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 80 -j ACCEPT
3. 拒絕所有IP 訪問 80 port
iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 80 -j ACCEPT
4. 砍規則
iptables -D INPUT -s 0.0.0.0/0 -p tcp --dport 80 -j ACCEPT

iptables -D sshguard -s 172.16.97.10 -j DROP



## 相關文件
* DNS解析原理
https://medium.com/starbugs/%E9%80%A3-pm-%E4%B9%9F%E6%87%89%E8%A9%B2%E7%9F%A5%E9%81%93%E7%9A%84-dns-%E5%B0%8F%E7%9F%A5%E8%AD%98-d00b43e4fe9a















## local linux 防火牆
* local
1. 查看目前防火牆規則
iptables -L -n 
2. 接受所有IP 訪問 80 port
iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 80 -j ACCEPT
3. 拒絕所有IP 訪問 80 port
iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 80 -j ACCEPT
4. 砍規則
iptables -D INPUT -s 0.0.0.0/0 -p tcp --dport 80 -j ACCEPT


* module
sudo apt-get install ufw
sudo ufw status //防火牆
sudo ufw enable
sudo apt-get install gufw
sudo ufw allow in 80


設定機器ip > 前面在wp-config檔案裡的 define 的IP也要同時更改
1. 設定機器固定IP
ifconfig eno1 172.23.1.20 netmask 255.255.255.0

2. 設定 route
route add default gw 172.23.1.254 eno1

3. 設定開機自動綁定IP和Route

cat > /route_add.sh << EOF
#!/bin/bash
ifconfig eno1 172.23.1.20 netmask 255.255.255.0
route add default gw 172.23.1.254 eno1
EOF

cat > /etc/systemd/system/route_add.service << EOF
[Unit]
After=network.service
Description=route_add

[Service]
ExecStart=/route_add.sh
Type=simple

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart route_add.service
systemctl enable route_add.service

sudo nano /etc/network/interfaces > 新增四行(如果有dhcp要把dhcp註解掉)
// 有tab 但某些linux無效
auto eh0
    iface eh0 inet static
    address X.X.X.X
    network X.X.X.X
    gateway X.X.X.X
    dns-nameservers X.X.X.X

設定完重新啟動:
sudo /etc/init.d/networking restart
or
sudo systemctl restart systemd-networkd
