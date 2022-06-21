# install
https://askubuntu.com/questions/1138428/how-can-i-connect-to-a-forticlient-ssl-vpn-via-terminal

wget http://cdn.software-mirrors.com/forticlientsslvpn_linux_4.4.2328.tar.gz
tar -xzvf forticlientsslvpn_linux_4.4.2328.tar.gz
sudo apt-get install ppp expect -y
cd ./forticlientsslvpn/64bit/helper
sudo ./setup.linux.sh 
../
./forticlientsslvpn_cli --server serveraddress:port --vpnuser username

```
#!/usr/bin/expect -d
set timeout 30
cd /forticlientsslvpn/64bit
spawn ./forticlientsslvpn_cli --server ip:10443 --vpnuser name
expect "Password for VPN:" {send -- "password\r"}
expect "to this server? (Y/N)\r" {send -- "y\r"}
expect eof
```

chmod +x sh.sh