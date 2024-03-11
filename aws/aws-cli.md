
# aws-cli
* install
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

* set IAM
aws configure
建立的IAM 要建立 Access key ID 和 Secret access key 以及 region ap-northeast-1
並且建立群組並且綁定權限
類似 GCP 建立 Service Account 產生 Json

* check current user
aws sts get-caller-identity

* set iam-role to ec2
aws ec2 associate-iam-instance-profile --iam-instance-profile Name=AmazonSSMRoleForInstancesQuickSetup --instance-id i-041a9f1804945d1d4


# ec2

* EC2 list
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,PublicDNS:PublicDnsName,PrivateDNS:PrivateDnsName,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress}'


* set iam-role to ec2
aws ec2 associate-iam-instance-profile --iam-instance-profile Name=AmazonSSMRoleForInstancesQuickSetup --instance-id i-041a9f1804945d1d4

# S3
aws s3 mb s3://linx-s3-test
aws s3 rb s3://linx-s3-test

aws s3 cp /var/www/test.txt s3://linx-s3-test
aws s3 cp s3://linx-s3-test/test.txt /var/www/test.txt
aws s3 rm s3://linx-s3-test/test.txt

aws s3 ls
aws s3 ls s3://linx-s3-test


# firewall

* firewall list
aws ec2 describe-security-groups --query 'SecurityGroups[].{ID:GroupId,Name:GroupName}'

# ecr

* create repository
aws ecr create-repository --repository-name linx-img-test --region ap-northeast-1

* login
aws ecr get-login-password --region [region] | docker login --username AWS --password-stdin [account].dkr.ecr.[region].amazonaws.com
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 234398048709.dkr.ecr.ap-northeast-1.amazonaws.com

* push
docker tag [local-image]:[tag] [account].dkr.ecr.[region].amazonaws.com/[repository-name]:[tag]
docker tag nodejs-template:1.0 234398048709.dkr.ecr.ap-northeast-1.amazonaws.com/linx-img-test:1.0
docker push 234398048709.dkr.ecr.ap-northeast-1.amazonaws.com/linx-img-test:1.0


# ecs
aws ecs update-service --cluster <cluster-name> --service <service-name> --task-definition <new-task-definition>

