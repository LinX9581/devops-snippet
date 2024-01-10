resource "aws_instance" "test2" {
  ami           = "ami-0c55b159cbfafe1f0"  # 請替換為最新的 Ubuntu 20.04 AMI
  instance_type = "t2.micro"
  iam_instance_profile                 = "AmazonSSMRoleForInstancesQuickSetup"
  
  user_data = <<EOF
#!/bin/bash
sudo adduser ansible
sudo usermod -aG sudo ansible
echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible
mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDTHDA7v/Pmm83OellAFrc67IEZIU31C9ovuCFYDTFCeeHyk61gHno7K+lcjue55RaH/8hFetHIbe9uLP8LqkumKHoHdwVzTkaxAuthRxDAh1HtBhddoxMmKJuDOxFMvUjvcnB+sPcot39AAPJPDR3c3QxAWUul7pjouma8OEjuBzNNNDL4cHY7sMsvQBhOepgaZmofMS41XSqm1uNW7gli6Ep0ISUSLm+iWZzqpwG1LJW/i9Imd2RWX9gAJ69/JyrmnjUswSL+2aoiF+UGzGx/pZcYK+iZY+ZIC22hYkENeAU+8ZfCHX5lKAvMu/R71N4BA/Nb/L6HrxPYVJcc1zLK1BMQGgdzUAMSV/PK/3A29uTjzKsTwAzbrpB5UTNaUQw559waYfFP126P9WLvjXkiA2dAqJNeqRf/NiJBfthmVSpiEos5xLWTL2ErtIkGc5NLsmG8z8fx4tIStK7/aXLKgm2Rr+cHrTxt9TTvo3+K/Fpj2Mxv5QljghF/Mu4sNLk= ansible@MSI
' >> /home/ansible/.ssh/authorized_keys
sudo chown ansible:ansible /home/ansible
sudo chmod 700 /home/ansible
chmod 600 /home/ansible/.ssh/authorized_keys
chown ansible:ansible /home/ansible/.ssh -R

EOF


  security_groups   = ["ec2-allow-other"]
  tags = {
    Name = "test2"
  }
}