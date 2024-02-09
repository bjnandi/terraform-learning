resource "aws_route53_zone" "primary" {
  name = "biswajitnandi.com"
}



resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "biswajitnandi.com"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}