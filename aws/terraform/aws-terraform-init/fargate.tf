# # 創建 ECS 執行角色
# resource "aws_iam_role" "ecs_execution_role" {
#   name = "${local.project_name}-ecs-execution-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# # 附加 ECS 任務執行角色策略
# resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
#   role       = aws_iam_role.ecs_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# # 創建 ECS 集群
# resource "aws_ecs_cluster" "nodejs_cluster" {
#   name = "nodejs-cluster"
# }

# # 定義任務定義
# resource "aws_ecs_task_definition" "nodejs_task" {
#   family                   = "${local.project_name}-nodejs-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "256"
#   memory                   = "512"
#   execution_role_arn       = aws_iam_role.ecs_execution_role.arn

#   container_definitions = jsonencode([{
#     name  = "${local.project_name}-nodejs-container"
#     image = "234398048709.dkr.ecr.ap-northeast-1.amazonaws.com/nodejs-template:1.5"
#     portMappings = [{
#       containerPort = 3005
#       hostPort      = 3005
#     }]
#   }])
# }

# # 創建 ECS 服務
# resource "aws_ecs_service" "nodejs_service" {
#   name            = "nodejs-service"
#   cluster         = aws_ecs_cluster.nodejs_cluster.id
#   task_definition = aws_ecs_task_definition.nodejs_task.arn
#   launch_type     = "FARGATE"
#   desired_count   = 1

#   network_configuration {
#     subnets          = [aws_subnet.subnetwork.id, aws_subnet.subnetwork_2.id]
#     assign_public_ip = true
#     security_groups  = [aws_security_group.allow-http.id,aws_security_group.allow-other.id]
#   }
# }