#1- Assign-Provider

provider "aws" {
  region     = "ap-south-1"
  profile = "Biswajit"
}

#2- Create-vpc and vpc_id

resource "aws_vpc" "bj-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" #gives an internal domain name
    enable_dns_hostnames = "true" #gives an internal host name
    instance_tenancy = "default"    
    tags = {
        Name = "bj-VPC"
    }
}

output "aws_vpc_id" {
  value = "${aws_vpc.bj-vpc.id}"
}

#3- Create-subnet and subnet_id

resource "aws_subnet" "bj-subnet" {
    vpc_id = "${aws_vpc.bj-vpc.id}"
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "ap-south-1a"
    tags = {
        Name = "bj-subnet"
    }
}

output "aws_subnet_id" {
  value = "${aws_subnet.bj-subnet.id}"
}

#4- Create- internet_gateway and internet_gateway_id

resource "aws_internet_gateway" "bj-igw" {
    vpc_id = "${aws_vpc.bj-vpc.id}"
       tags = {
       Name = "bj-igw"
                }
  }

output "aws_internet_gateway_id" {
  value = "${aws_internet_gateway.bj-igw.id}"
}

#5- Create- route_table and route_table_id

  resource "aws_route_table" "bj-route" {
    vpc_id = "${aws_vpc.bj-vpc.id}"
        route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.bj-igw.id}"
    }
     tags = {
        Name = "bj-route"
    }
}

output "aws_route_table_id" {
    value = "${aws_route_table.bj-route.id}"
}

#6- Associate- route_table_associarion with route_table

resource "aws_route_table_association" "bj-route" {
  subnet_id   = "${aws_subnet.bj-subnet.id}"
  route_table_id = "${aws_route_table.bj-route.id}"
}


#7 Create- Security Group and Security Group_id

resource "aws_security_group" "bj-port-allowed" {
    description = "allow limited inbound external traffic"
    vpc_id = "${aws_vpc.bj-vpc.id}"
   
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production.
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the bj-Server  
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
   tags = {
       Name = "bj-port-allowed"
   }
}

    #8 Create- Key Pair & Key_Pair_ID

    resource "aws_key_pair" "bj_Key" {
        key_name = "bj_Key"
        public_key = tls_private_key.rsa.public_key_openssh
    }
    
    # RSA key of size 4096 bits
    resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits  = 4096
    }

    resource "local_file" "bj_Key" {
        content  = tls_private_key.rsa.private_key_pem
        filename = "bjkey"
    }

#9 Create- EC2_Instance and instance_id

resource "aws_instance" "bj-Server" {
    ami = "ami-079b5e5b3971bd10d" #Amazon Linux AMI
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.bj-subnet.id}"
    security_groups = ["${aws_security_group.bj-port-allowed.id}"]
    key_name = "bj_Key"
    
    tags = {
        Name = "bj-Server"
    }
}