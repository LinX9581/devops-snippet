# Ansible 安裝方式
sudo apt install ansible

* 如果佈署的機器 python 太新 ansible 需要更新
sudo apt remove ansible
sudo apt autoremove
sudo pip3 install ansible

## 執行方式

預設設定檔吃 /etc/ansible/hosts
cat>/etc/ansible/hosts<<EOF
[servers]
server1 ansible_host=203.0.113.111
server2 ansible_host=203.0.113.112

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_user=lin
ansible_ssh_private_key_file=/root/.ssh/id_rsa
EOF

可以自訂 host 位置以及名稱 和 playbook 位置
ansible-playbook -i /host/test ./yaml/cicd/create_service.yml -e 'host=nn-client'

## ssh 進去機器不會要求確認
* 加參數清除快取
--flush-cache 

* 改設定永久清除快取
host_key_checking = False

## ssh 代理
~/.bash.rc
eval $(ssh-agent)
ssh-add ~/.ssh/gitlab-deploy-ssh/id_rsa
source ~/.bash.rc

## ansilble 指令 用法
-m：要執行的模塊，默認為command
-a：模塊的參數
-u：ssh連接的用戶名，默認用root，ansible.cfg中可以配置
-k：提示輸入ssh登錄密碼，當使用密碼驗證的時候用
-s：sudo運行
-U：sudo到哪個用戶，默認為root
-K：提示輸入sudo密碼，當不是NOPASSWD模式時使用
-C：只是測試一下會改變什麽內容，不會真正去執行
-c：連接類型(default=smart)
-f：fork多少進程並發處理，默認為5個
-i：指定hosts文件路徑，默認default=/etc/ansible/hosts
-I：指定pattern，對已匹配的主機中再過濾一次
--list-host：只打印有哪些主機會執行這個命令，不會實際執行
-M：要執行的模塊路徑，默認為/usr/share/ansible
-o：壓縮輸出，摘要輸出
--private-key：私鑰路徑
-T：ssh連接超時時間，默認是10秒
-t：日誌輸出到該目錄，日誌文件名以主機命名
-v：顯示詳細日誌