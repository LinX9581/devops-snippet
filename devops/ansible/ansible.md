# begin
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

ansible all -a "df -h"

## 基本 playbook
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

## 改成自建設定檔
cp /etc/ansible/hosts /etc/ansible/inventory
ansible all -i inventory -m ping
ansible atom -i inventory -a "sysctl -a | grep conntrack"
sysctl -a | grep conntrack
## ssh 進去機器不會要求確認
echo -> ansible.cfg (如果機器都是固定則拿掉)
host_key_checking = False

## 自建 playbook
ansible-playbook -i inventory sh.yml


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