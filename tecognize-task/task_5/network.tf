
### Resource

## Create a VPC
resource "aws_vpc" "vpc_main" {
  cidr_block           = var.aws_cidr_block
  instance_tenancy     = var.aws_instance_tenancy
  enable_dns_hostnames = var.aws_enable_dns_hostnames

  tags = local.common_tag

}


## Subnet available
data "aws_availability_zones" "available" {
  state = "available"
}

## Create a Subnet one
resource "aws_subnet" "subnet_one" {
  availability_zone       = data.aws_availability_zones.available.names[0]
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.aws_subnet_cidr_one
  map_public_ip_on_launch = var.aws_map_public_ip_on_launch

  tags = local.common_tag
}

## Create a Subnet two
resource "aws_subnet" "subnet_two" {
  availability_zone       = data.aws_availability_zones.available.names[1]
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.aws_subnet_cidr_two
  map_public_ip_on_launch = var.aws_map_public_ip_on_launch

  tags = local.common_tag
}


## Create internet gateway
resource "aws_internet_gateway" "gw_main" {
  vpc_id = aws_vpc.vpc_main.id

  tags = local.common_tag
}

## Create route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = var.aws_route_table_cidr
    gateway_id = aws_internet_gateway.gw_main.id
  }

  tags = local.common_tag
}

## Create route table association
resource "aws_route_table_association" "route_table_a_one" {
  subnet_id      = aws_subnet.subnet_one.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_a_two" {
  subnet_id      = aws_subnet.subnet_two.id
  route_table_id = aws_route_table.route_table.id
}

## Security group
resource "aws_security_group" "ins-sg" {
  vpc_id = aws_vpc.vpc_main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

  tags = local.common_tag

}
## Security group
resource "aws_security_group" "lb-sg" {
  vpc_id = aws_vpc.vpc_main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

  tags = local.common_tag

}
## Create key pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

## RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Download key pair
resource "local_file" "ec2_Key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ec2_key"
}

