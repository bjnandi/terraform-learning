## EC2 instance
resource "aws_instance" "server_1" {
  ami                    = var.aws_instance_ami
  instance_type          = var.aws_instance_machine_image
  subnet_id              = aws_subnet.subnet_one.id
  vpc_security_group_ids = [aws_security_group.ins-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.iam_instance_profile.name
  depends_on             = [aws_iam_role_policy.allow-s3-all]
  key_name               = "ec2_key"
  user_data              = <<EOF
  #! /bin/bash
  sudo amazon-linux-extras install nginx1 -y
  sudo rm -f /usr/share/nginx/html/index.html
  aws s3 cp s3://${aws_s3_bucket.s3-bucket.id}/website/index-1.html /home/ec2-user/index.html
  sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
  sudo service nginx start  
  EOF

  tags = local.common_tag
}


resource "aws_instance" "server_2" {
  ami                    = var.aws_instance_ami
  instance_type          = var.aws_instance_machine_image
  subnet_id              = aws_subnet.subnet_two.id
  vpc_security_group_ids = [aws_security_group.ins-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.iam_instance_profile.name
  depends_on             = [aws_iam_role_policy.allow-s3-all]
  key_name               = "ec2_key"
  user_data              = <<EOF
  #! /bin/bash
  sudo amazon-linux-extras install nginx1 -y
  sudo rm -f /usr/share/nginx/html/index.html
  aws s3 cp s3://${aws_s3_bucket.s3-bucket.id}/website/index-2.html /home/ec2-user/index.html
  sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
  sudo service nginx start   
  EOF

  tags = local.common_tag
}