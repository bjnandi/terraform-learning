## EC2 instance
resource "aws_instance" "server_1" {
  ami                    = var.aws_instance_ami
  instance_type          = var.aws_instance_machine_image
  subnet_id              = aws_subnet.subnet_one.id
  vpc_security_group_ids = [aws_security_group.ins-sg.id]
  key_name               = "ec2_key"
  user_data              = <<EOF
  #! /bin/bash
  sudo amazon-linux-extras install nginx1
  sudo service nginx start
  sudo rm -f /usr/share/nginx/html/index.html
  echo "server one" | sudo tee -a /usr/share/nginx/html/index.html
  EOF

  tags = local.common_tag
}


resource "aws_instance" "server_2" {
  ami                    = var.aws_instance_ami
  instance_type          = var.aws_instance_machine_image
  subnet_id              = aws_subnet.subnet_two.id
  vpc_security_group_ids = [aws_security_group.ins-sg.id]
  key_name               = "ec2_key"
  user_data              = <<EOF
  #! /bin/bash
  sudo amazon-linux-extras install nginx1
  sudo service nginx start
  sudo rm -f /usr/share/nginx/html/index.html
  echo "server two" | sudo tee -a /usr/share/nginx/html/index.html
  EOF

  tags = local.common_tag
}