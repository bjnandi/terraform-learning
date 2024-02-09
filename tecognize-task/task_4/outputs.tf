output "Domian-Name-Server" {
  value = aws_route53_zone.primary.name_servers
}

