
* gen ssh key
ssh-keygen -t rsa

* 清除重複的連線
ssh-keygen -R 伺服器端的IP或網址

* 執行多腳本
ssh -o StrictHostKeyChecking=no lin@34.92.123.5 "sudo sh /shell/a.sh && sudo sh /shell/b.sh && sudo sh /shell/c.sh"




