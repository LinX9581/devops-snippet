variable "az_list" {
  description = "A list of Availability Zones"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]  # 你可以根据需要更改默认值
}

# Declare vpc and ip range
resource "aws_vpc" "workout-app-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Workout App VPC"
  }
}

# Declare public subnet for nginx sercer
resource "aws_subnet" "public_subnet_lb" {
  count = 2

  vpc_id = aws_vpc.workout-app-vpc.id

  cidr_block = "10.0.${count.index + 1}1.0/24"

  availability_zone = "${var.az_list[count.index]}"

  # For public subnet
  map_public_ip_on_launch = true
  
  tags = {
    Name = "Load Balancer Public Subnet [${element(var.az_list, count.index)}]"
  }
}

# Declare private subnet for app server
resource "aws_subnet" "private_subnet_app" {
  count = 2

  vpc_id = aws_vpc.workout-app-vpc.id

  cidr_block = "10.0.${count.index + 1}2.0/24"

  availability_zone = "${var.az_list[count.index]}"

  # For private subnet
  map_public_ip_on_launch = false
  
  tags = {
    Name = "App Private Subnet [${var.az_list[count.index]}]"
  }
}

# Declare private subnet for database
resource "aws_subnet" "private_subnet_db" {
  count = 2

  vpc_id = aws_vpc.workout-app-vpc.id

  cidr_block = "10.0.${count.index + 1}3.0/24"

  availability_zone = "${var.az_list[count.index]}"

  # For private subnet
  map_public_ip_on_launch = false
  
  tags = {
    Name = "Database Private Subnet [${var.az_list[count.index]}]"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "tf-workout-igw" {
  tags = {
    Name = "tf-workout-igw"
  }
  vpc_id = aws_vpc.workout-app-vpc.id
}

# Route table
resource "aws_route_table" "worout-web-access-rt" {
  vpc_id = aws_vpc.workout-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-workout-igw.id
  }

  tags = {
    Name = "Web Access for Workout App"
  }
}

# Associate route table and subnet
resource "aws_route_table_association" "public-subnet-rta" {
  count = 2
  subnet_id      = element(aws_subnet.public_subnet_lb, count.index).id
  route_table_id = aws_route_table.worout-web-access-rt.id
}