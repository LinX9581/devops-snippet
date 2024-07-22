# resource "aws_vpc" "vpc_network" {
#   cidr_block = "172.16.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "${local.project_name}-vpc"
#   }
# }

# resource "aws_subnet" "public_subnet" {
#   vpc_id            = aws_vpc.vpc_network.id
#   cidr_block        = "172.16.0.0/24"
#   availability_zone = "ap-northeast-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${local.project_name}-public-subnet"
#   }
# }

# resource "aws_subnet" "subnetwork_1" {
#   vpc_id            = aws_vpc.vpc_network.id
#   cidr_block        = "172.16.1.0/24"
#   availability_zone = "ap-northeast-1c"

#   tags = {
#     Name = "${local.project_name}-subnet-1"
#   }
# }

# resource "aws_subnet" "subnetwork_2" {
#   vpc_id            = aws_vpc.vpc_network.id
#   cidr_block        = "172.16.2.0/24"
#   availability_zone = "ap-northeast-1a"

#   tags = {
#     Name = "${local.project_name}-subnet-2"
#   }
# }

# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id = aws_vpc.vpc_network.id

#   tags = {
#     Name = "${local.project_name}-igw"
#   }
# }

# resource "aws_eip" "nat_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "${local.project_name}-nat-eip"
#   }
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet.id

#   tags = {
#     Name = "${local.project_name}-nat-gateway"
#   }
# }

# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.vpc_network.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.internet_gateway.id
#   }

#   tags = {
#     Name = "${local.project_name}-public-route-table"
#   }
# }

# resource "aws_route_table_association" "public_route_table_association" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table_association" "deploy_route_table_association" {
#   subnet_id      = aws_subnet.subnetwork_2.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.vpc_network.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gateway.id
#   }

#   tags = {
#     Name = "${local.project_name}-private-route-table"
#   }
# }

# resource "aws_route_table_association" "private_route_table_association" {
#   subnet_id      = aws_subnet.subnetwork_1.id
#   route_table_id = aws_route_table.private_route_table.id
# }

# resource "aws_route" "internet_access" {
#   route_table_id         = aws_route_table.public_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.internet_gateway.id
# }
