## 

* 全域啟用 Serial Console
GCE 的 metadata
serial-port-enable : TRUE


* VM 開機執行腳本建立使用者
#!/bin/bash
adduser nn-admin
echo nn-admin:28331543 | chpasswd
usermod -aG google-sudoers nn-admin

* 重開機
進入 Serial Console 輸入上面帳密
 
## Serial Console 進不去的處理方式
停機編輯 meta-data
add systemd.unit=emergency.target
reboot