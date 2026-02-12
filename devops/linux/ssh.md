
* gen ssh key
ssh-keygen -t rsa

* 清除重複的連線
ssh-keygen -R 伺服器端的IP或網址

* 執行多腳本
ssh -o StrictHostKeyChecking=no lin@34.92.123.5 "sudo sh /shell/a.sh && sudo sh /shell/b.sh && sudo sh /shell/c.sh"

## 修改 SSH 設定
/etc/ssh/sshd_config

* 禁止用密碼登入 預設就是 no
PasswordAuthentication no
* 允許用 ssh key 登入
PubkeyAuthentication yes
PermitRootLogin no
* 只允許ansible 可以ssh
AllowUsers ansible

sudo systemctl restart sshd

* 加入特定使用者為root
echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible >/dev/null

* proxy
~/.bash.rc
eval $(ssh-agent)
ssh-add ~/.ssh/gitlab-deploy-ssh/id_rsa
source ~/.bash.rc
