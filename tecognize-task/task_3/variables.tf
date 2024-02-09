variable "aws_access_key" {
  type        = string
  description = "AWS access Key"
  sensitive   = true
  #default = " "
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret Key"
  sensitive   = true
  # default = " "
}

variable "region" {
  type        = string
  description = "AWS secret Key"
  default     = "us-east-1"
}

variable "aws_cidr_block" {
  type        = string
  description = "AWS cidr block"
  default     = "10.0.0.0/16"
}


variable "aws_instance_tenancy" {
  type        = string
  description = "AWS instance tenancy"
  default     = "default"
}

variable "aws_enable_dns_hostnames" {
  type        = bool
  description = "AWS enable dns hostnames"
  default     = "true"
}

variable "aws_subnet_cidr_one" {
  type        = string
  description = "AWS subnet cidr block"
  default     = "10.0.0.0/24"
}
variable "aws_subnet_cidr_two" {
  type        = string
  description = "AWS subnet cidr block"
  default     = "10.0.1.0/24"
}
variable "aws_map_public_ip_on_launch" {
  type        = bool
  description = "AWS map public ip on launch"
  default     = "true"
}

variable "aws_route_table_cidr" {
  type        = string
  description = "AWS route table cidr"
  default     = "0.0.0.0/0"
}


variable "aws_instance_ami" {
  type        = string
  description = "AWS instance ami"
  default     = "ami-0b5eea76982371e91"
}

variable "aws_instance_machine_image" {
  type        = string
  description = "AWS instance machine image"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "Company name"
  default     = "BjTech"
}

variable "project" {
  type        = string
  description = "project name"
  default     = "Youtube Video"
}