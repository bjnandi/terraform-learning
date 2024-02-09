output "aws_instance_public_ip" {
    value = aws_instance.test_ec2.public_ip
}