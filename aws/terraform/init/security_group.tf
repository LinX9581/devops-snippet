
variable "common_ip_source_ranges" {
  description = "allow internal traffic"
  type        = list(string)
  default     = ["172.20.16.0/24"]
}

resource "aws_security_group" "allow-other" {
  name        = "${local.project_name}-allow-other"
  description = "Security group for allowing specific traffic"
  vpc_id      = aws_vpc.vpc_network.id

  ingress {
    description = "Node-Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = concat(
      ["35.236.154.220/32"],
      var.common_ip_source_ranges
    )
  }

  ingress {
    description = "Proccess Exporter"
    from_port   = 9256
    to_port     = 9256
    protocol    = "tcp"
    cidr_blocks = ["35.236.154.220/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-allow-other"
  }
}

resource "aws_security_group" "allow-http" {
  name        = "${local.project_name}-allow-http"
  description = "Security group for allowing specific traffic"
  vpc_id      = aws_vpc.vpc_network.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-allow-http"
  }
}

resource "aws_security_group" "allow-https" {
  name        = "${local.project_name}-allow-https"
  description = "Security group for allowing specific traffic"
  vpc_id      = aws_vpc.vpc_network.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-allow-https"
  }
}

resource "aws_security_group" "allow-ssh" {
  name        = "${local.project_name}-allow-ssh"
  description = "Security group for allowing specific traffic"
  vpc_id      = aws_vpc.vpc_network.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project_name}-allow-ssh"
  }
}
