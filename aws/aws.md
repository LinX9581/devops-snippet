## IAM
已群組為概念，一個群組可以有多個使用者，一個使用者可以有多個群組
預設的使用者沒有權限 要先建立群組並且綁定

## SSH
* 統一讓每台EC2
System Manager ( EC2 必須要有 SSM 權限)
防火牆 outbount 要開 443
Create Host Management
AWS-RunShellScript

建立無密碼的 ansible 使用者
```
sudo adduser ansible
sudo usermod -aG sudo ansible
echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
echo '' >> /home/ansible/.ssh/authorized_keys
sudo chown ansible:ansible /home/ansible
sudo chmod 700 /home/ansible
chmod 600 /home/ansible/.ssh/authorized_keys
chown ansible:ansible /home/ansible/.ssh -R
```

## Loadbalancer
一般網站適合用 ALB (HTTP/HTTPS)
建立的時候預設會用兩個區域 所以要建立兩個 vpc subnet 否則綁定 cloudfront 有時候會504
ALB 是會被 security group 控管 , 相比 GCP LB 不會被 firewall 控管只能被 armor 控管

## AWS 和 GCP 差異
VM的詳細資料 EC2 Sidebar 就很清楚了 GCP還要點進去
網頁的SSH AWS快超多 但沒辦法上下傳檔案
rds 可以直接用DNS連線 而不是IP 不像GCP一定用IP除非用 sql proxy

建立 Target Group 後才能建立 Loadbalancer
再把建立好的 Loadbalancer 取得的 DNS 設定到 Cloudfront 的 Origin

## SSH
Key pair 要選 .pem vscode 才能 remote ssh 