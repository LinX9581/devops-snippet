# Ansible
cd ./devops-snippet/devops/ansible

## 安裝後端環境
* install oracle java
ansible-playbook -i ./host/test ./yaml/setup_env/java.yml

* install php8.0
ansible-playbook -i ./host/test ./yaml/setup_env/php.yml --extra-vars 'host=local'

* install wordpress
ansible-playbook -i ./host/test ./yaml/setup_env/wordpress.yml

* install docker
ansible-playbook -i ./host/test ./yaml/setup_env/docker.yml --extra-vars 'host=local'

* install nodejs 18
ansible-playbook -i ./host/test ./yaml/setup_env/nodejs.yml --extra-vars 'host=local'

## 安裝監控環境
* prometheus (會先上傳exporter, 再寫成service 讓他保持重開機自動執行)
ansible-playbook -i ./host/test ./yaml/monit/exporter-local.yml --extra-vars 'host=local'
ansible-playbook -i ./host/test ./yaml/monit/exporter-docker.yml --extra-vars 'host=local'

* GCP OPS Agent
ansible-playbook -i ./host/test ./yaml/monit/gcp-monit.yml

* GCP Logging Agent / auth log history
ansible-playbook -i ./host/test ./yaml/monit/gcp-custom-log.yml

* promtail
ansible-playbook -i ./host/test ./yaml/monit/promtail.yml

## 其他

* 查看系統資訊
ansible-playbook -i ./host/test ./yaml/cmd/show-system-info.yml --extra-vars 'host=local'

* 顯示系統環境變數
ansible-playbook -i ./host/test ./yaml/cmd/show-system-env.yml --extra-vars 'host=local'

* 清除未使用的使用者
ansible-playbook -i ./host/test ./yaml/cmd/delete_useless_user.yml --extra-vars 'host=local'

* git pull
deploy_git.yml

* 變數相關
ansible-playbook -i ./host/test ./yaml/cmd/vars.yml

# Ansible 安裝方式
* 參考
https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-20-04
https://pin-yi.me/ansible/

sudo apt install ansible

## 預設設定檔吃 /etc/ansible/hosts
cat>/etc/ansible/hosts<<EOF
[servers]
server1 ansible_host=203.0.113.111
server2 ansible_host=203.0.113.112

[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_user=lin
ansible_ssh_private_key_file=/root/.ssh/id_rsa
EOF

## 改成自建設定檔
cp /etc/ansible/hosts /etc/ansible/inventory

## 自建 playbook
vars_prompt -> 輸入指令不會馬上執行 需要輸入參數

cat>/etc/ansible/env.yml<<EOF
---
- name: Copy and Run shell scripts on remote machine
  vars_prompt:
    - name: host
      prompt: What is your host?
      private: no

  hosts: '{{ host }}'
  tasks:
    - name: show tcp_fin_timeout
      shell: "sudo sysctl -a | grep tcp_fin_timeout"
      register: tcp_fin_timeout

    - name: Print
      debug:
        msg: "'{{ tcp_fin_timeout.stdout }}'"
EOF

* 用自建設定檔 & playbook
ansible-playbook -i inventory env.yml
ansible-playbook -i ./host/new ./yaml/upload.yml

* 對所有host下指令
ansible all -i inventory -m ping
ansible atom -i inventory -a "sysctl -a | grep conntrack"


## ssh 進去機器不會要求確認
echo -> ansible.cfg (如果機器都是固定則拿掉)
* 加這個也會順便清除舊的 known_host
* --flush-cache 
host_key_checking = False

## ssh 代理
* 啟動 ssh 代理
eval $(ssh-agent)

* 增加代理ssh key
ssh-add gitlab-deploy-ssh/id_rsa

* 更改 ansible 設定檔
echo -> ansible.cfg
[ssh_connection]
ssh_args = -o ForwardAgent=yes 

## ansilble 指令 用法
https://www.796t.com/content/1525534899.html
https://ithelp.ithome.com.tw/articles/10205652

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