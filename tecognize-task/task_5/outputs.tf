output "Domian-Name-Server" {
  value = aws_route53_zone.primary.name_servers
}



output "aws_instance_public_dns" {
  value = aws_lb.alb.dns_name
}