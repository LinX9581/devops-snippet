resource "aws_vpc" "vpc_network" {
  cidr_block = "172.20.16.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.project_name}-vpc"
  }
}

resource "aws_subnet" "subnetwork" {
  vpc_id            = aws_vpc.vpc_network.id
  cidr_block        = "172.20.16.0/24"
  availability_zone = "ap-northeast-1a" # 或您選擇的其他適當可用區

  tags = {
    Name = "${local.project_name}-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_network.id

  tags = {
    Name = "${local.project_name}-igw"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.vpc_network.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}
