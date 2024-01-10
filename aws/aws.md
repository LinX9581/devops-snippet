
## AWS CLI
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

* set IAM
aws configure
建立的IAM 要建立 Access key ID 和 Secret access key 以及 region ap-northeast-1
並且建立群組並且綁定權限

* check current user
aws sts get-caller-identity

* set iam-role to ec2
aws ec2 associate-iam-instance-profile --iam-instance-profile Name=AmazonSSMRoleForInstancesQuickSetup --instance-id i-041a9f1804945d1d4

## IAM
已群組為概念，一個群組可以有多個使用者，一個使用者可以有多個群組
預設的使用者沒有權限 要先建立群組並且綁定

## Cloud shell

* EC2 list
aws ec2 describe-instances --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name}'

* firewall list
aws ec2 describe-security-groups --query 'SecurityGroups[].{ID:GroupId,Name:GroupName}'

## SSH
System Manager 
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

## Route53
Create hosted zone
設定網域後 把 Godday ns 改成 AWS 的 ns
生效後就能建立 record

## AWS 和 GCP 差異
VM的詳細資料 EC2 Sidebar 就很清楚了 GCP還要點進去
網頁的SSH AWS快超多 但沒辦法上下傳檔案
rds 可以直接用DNS連線 而不是IP 不像GCP一定用IP除非用 sql proxy


## SSH
Key pair 要選 .pem vscode 才能 remote ssh 