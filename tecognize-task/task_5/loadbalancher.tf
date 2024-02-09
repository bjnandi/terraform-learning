## lb service account

data "aws_elb_service_account" "root" {}


## aws lb
resource "aws_lb" "alb" {

  name                       = "alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb-sg.id]
  subnets                    = [aws_subnet.subnet_one.id, aws_subnet.subnet_two.id]
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.s3-bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }


  tags = local.common_tag
}

## aws lb target group
resource "aws_lb_target_group" "lb_target_group" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_main.id

  tags = local.common_tag
}

## aws lb listener
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }

  tags = local.common_tag
}


## aws lb  target group attachment 
resource "aws_lb_target_group_attachment" "server_1" {
  target_group_arn = aws_lb_target_group.lb_target_group.arn
  target_id        = aws_instance.server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "server_2" {
  target_group_arn = aws_lb_target_group.lb_target_group.arn
  target_id        = aws_instance.server_2.id
  port             = 80
}