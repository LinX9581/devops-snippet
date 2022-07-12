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

## 改成自建設定檔
cp /etc/ansible/hosts /etc/ansible/inventory
ansible all -i inventory -m ping

## 自建 playbook
ansible-playbook -i inventory sh.yml

