# # ALB
# resource "aws_lb" "alb" {
#   name               = "${local.project_name}-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.allow-http.id, aws_security_group.allow-https.id]
#   subnets            = [aws_subnet.subnetwork_1.id, aws_subnet.subnetwork_2.id]

#   tags = {
#     Name = "${local.project_name}-alb"
#   }
# }

# # ALB 目標群組
# resource "aws_lb_target_group" "tg" {
#   name     = "${local.project_name}-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc_network.id

#   health_check {
#     path                = "/"
#     healthy_threshold   = 2
#     unhealthy_threshold = 10
#   }
# }

# # ALB 監聽器
# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }
# }

# # 啟動模板
# resource "aws_launch_template" "asg_launch_template" {
#   name_prefix   = "${local.project_name}-lt"
#   image_id      = "ami-0725956b42e41cc6e"  # ubuntu22.04
#   instance_type = "t2.micro"

#   network_interfaces {
#     associate_public_ip_address = false
#     security_groups             = [aws_security_group.allow-other.id, aws_security_group.allow-ssh.id, aws_security_group.allow-http.id, aws_security_group.allow-https.id]
#   }

#   iam_instance_profile {
#     name = var.iam_profile
#   }

#   key_name = var.key_name

#   # instance_market_options {
#   #   market_type = "spot"
#   #   spot_options {
#   #     max_price = "0.0034" # 設置您願意支付的最高價格，可以是按需價格或更低
#   #   }
#   # }

#   user_data = base64encode(<<EOF
# #!/bin/bash

# EOF
#   )

#   lifecycle {
#     create_before_destroy = true
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       version = "1.0.1"
#     }
#   }
# }

# # 自動擴展組
# resource "aws_autoscaling_group" "asg" {
#   name                = "${local.project_name}-asg"
#   vpc_zone_identifier = [aws_subnet.subnetwork_1.id, aws_subnet.subnetwork_2.id]
#   target_group_arns   = [aws_lb_target_group.tg.arn]
#   min_size            = 2
#   max_size            = 3
#   desired_capacity    = 2

#   launch_template {
#     id      = aws_launch_template.asg_launch_template.id
#     version = "$Latest"
#   }

#   instance_refresh {
#     strategy = "Rolling"
#     preferences {
#       min_healthy_percentage = 50
#     }
#   }

#   tag {
#     key                 = "Name"
#     value               = "${local.project_name}-asg-instance"
#     propagate_at_launch = true
#   }
# }

# # 輸出 ALB DNS 名稱
# output "alb_dns_name" {
#   value       = aws_lb.alb.dns_name
#   description = "ALB 的 DNS 名稱"
# }