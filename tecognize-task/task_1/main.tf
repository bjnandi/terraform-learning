### Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

## Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}


### Resource

## Create a VPC
resource "aws_vpc" "vpc_main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

}

## Create a Subnet
resource "aws_subnet" "subnet_main" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "true"

}

## Create internet gateway
resource "aws_internet_gateway" "gw_main" {
  vpc_id = aws_vpc.vpc_main.id

}

## Create route table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_main.id
  }


}
## Create route table association
resource "aws_route_table_association" "main_route_table_a" {
  subnet_id      = aws_subnet.subnet_main.id
  route_table_id = aws_route_table.main_route_table.id
}

## Security group
resource "aws_security_group" "test-sg" {
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

## EC2 instance
resource "aws_instance" "ins-1" {
  ami                    = "ami-0b5eea76982371e91"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet_main.id
  vpc_security_group_ids = [aws_security_group.test-sg.id]
  key_name               = "ec2_key"
  user_data              = <<EOF
  #! /bin/bash
  sudo amazon-linux-extras install nginx1
  sudo service nginx start
  EOF

}
