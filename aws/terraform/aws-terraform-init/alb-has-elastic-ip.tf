# # 創建 3 個彈性 IP
# resource "aws_eip" "asg_eips" {
#   count  = 3
#   domain = "vpc"
#   tags = {
#     Name = "asg-eip-${count.index + 1}"
#   }
# }

# # 創建 IAM 角色
# resource "aws_iam_role" "ec2_eip_role" {
#   name = "ec2_eip_association_role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # 創建 IAM 策略
# resource "aws_iam_role_policy" "ec2_eip_policy" {
#   name = "ec2_eip_association_policy"
#   role = aws_iam_role.ec2_eip_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ec2:DescribeAddresses",
#           "ec2:AssociateAddress"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# # 創建 IAM 實例配置文件
# resource "aws_iam_instance_profile" "ec2_eip_profile" {
#   name = "ec2_eip_profile"
#   role = aws_iam_role.ec2_eip_role.name
# }

# # 修改啟動模板
# resource "aws_launch_template" "asg_launch_template" {
#   name_prefix   = "${local.project_name}-lt"
#   image_id      = "ami-07c589821f2b353aa"  # ubuntu22.04
#   instance_type = "t2.micro"

#   iam_instance_profile {
#     name = aws_iam_instance_profile.ec2_eip_profile.name
#   }

#   network_interfaces {
#     associate_public_ip_address = true
#     security_groups             = [aws_security_group.allow-other.id, aws_security_group.allow-ssh.id, aws_security_group.allow-http.id, aws_security_group.allow-https.id]
#   }

#   key_name = var.key_name

#   user_data = base64encode(<<EOF
# #!/bin/bash
# apt update
# sudo timedatectl set-timezone Asia/Taipei
# apt install unzip net-tools awscli -y

# # 獲取實例 ID
# INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# # 獲取可用的彈性 IP
# EIP_ALLOCATION_ID=$(aws ec2 describe-addresses --filters "Name=domain,Values=vpc" "Name=tag:Name,Values=asg-eip-*" --query 'Addresses[?AssociationId==null].AllocationId' --output text --region ${data.aws_region.current.name} | awk '{print $1}')

# if [ ! -z "$EIP_ALLOCATION_ID" ]; then
#     # 關聯彈性 IP
#     aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $EIP_ALLOCATION_ID --region ${data.aws_region.current.name}
#     echo "Associated Elastic IP ($EIP_ALLOCATION_ID) with the instance ($INSTANCE_ID)"
# else
#     echo "No available Elastic IP found"
# fi

# # 其他設置腳本...
# sudo adduser ansible
# sudo usermod -aG sudo ansible
# echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible
# mkdir -p /home/ansible/.ssh
# chmod 700 /home/ansible/.ssh
# echo '${var.ssh_public_key}' >> /home/ansible/.ssh/authorized_keys
# sudo chown ansible:ansible /home/ansible
# sudo chmod 700 /home/ansible
# chmod 600 /home/ansible/.ssh/authorized_keys
# chown ansible:ansible /home/ansible/.ssh -R
# EOF
#   )

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "${local.project_name}-asg-instance"
#     }
#   }
# }

# # 自動擴展組設置保持不變
# resource "aws_autoscaling_group" "asg" {
#   # ... 其他設置保持不變 ...
#   launch_template {
#     id      = aws_launch_template.asg_launch_template.id
#     version = "$Latest"
#   }
#   # ... 其他設置保持不變 ...
# }

# # 輸出彈性 IP
# output "elastic_ips" {
#   value = aws_eip.asg_eips[*].public_ip
# }

# # 獲取當前區域
# data "aws_region" "current" {}