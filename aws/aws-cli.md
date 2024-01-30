
# ec2

* EC2 list
aws ec2 describe-instances --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name}'

* set iam-role to ec2
aws ec2 associate-iam-instance-profile --iam-instance-profile Name=AmazonSSMRoleForInstancesQuickSetup --instance-id i-041a9f1804945d1d4

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

