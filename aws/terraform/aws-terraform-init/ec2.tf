variable "instance_name" {
  type        = string
}

variable "iam_profile" {
  type        = string
}

variable "ssh_public_key" {
  type        = string
}

variable "key_name" {
  type        = string
}

# resource "aws_eip" "eip-2" {
#   instance = aws_instance.deploy-instance.id
#   domain = "vpc"
# }

resource "aws_instance" "deploy-instance" {
  ami           = "ami-0a290015b99140cd1"  # ubuntu22.04
  instance_type = "t2.micro"
  iam_instance_profile                 = var.iam_profile
  associate_public_ip_address = true 
  key_name               = var.key_name
  subnet_id               = aws_subnet.subnetwork_2.id
  vpc_security_group_ids = [aws_security_group.allow-other.id, aws_security_group.allow-ssh.id,aws_security_group.allow-http.id,aws_security_group.allow-https.id]

  root_block_device {
    encrypted   = true
    volume_size = 8
    volume_type = "gp2" # 免費額度支援 , gp3 IOPS 不是免費
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }

  user_data = <<EOF
#!/bin/bash
apt update
sudo timedatectl set-timezone Asia/Taipei
apt install unzip net-tools -y

apt install amazon-cloudwatch-agent -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

sudo adduser ansible
sudo usermod -aG sudo ansible
echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
echo '${var.ssh_public_key}' >> /home/ansible/.ssh/authorized_keys
sudo chown ansible:ansible /home/ansible
sudo chmod 700 /home/ansible
chmod 600 /home/ansible/.ssh/authorized_keys
chown ansible:ansible /home/ansible/.ssh -R

EOF

  tags = {
    Name = "prod-deploy"
  }
}

# # 只有內部IP 但有對外NAT IP
# resource "aws_instance" "instance1" {
#   ami           = "ami-07c589821f2b353aa"  # ubuntu22.04
#   instance_type = "t2.micro"
#   iam_instance_profile                 = var.iam_profile
#   associate_public_ip_address = false
#   key_name               = var.key_name
#   subnet_id               = aws_subnet.subnetwork.id
#   vpc_security_group_ids = [aws_security_group.allow-other.id, aws_security_group.allow-ssh.id,aws_security_group.allow-http.id,aws_security_group.allow-https.id]

#   user_data = <<EOF
# #!/bin/bash
# apt update
# sudo timedatectl set-timezone Asia/Taipei
# apt install unzip net-tools -y

# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install
# sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

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

#   tags = {
#     Name = var.instance_name
#   }
# }