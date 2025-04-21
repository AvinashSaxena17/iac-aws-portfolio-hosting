resource "aws_lb" "prod-alb" {
  name               = "prod-aws-ec2-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Allow-inbound-outbound.id]
  subnets            = [ aws_subnet.public-subnet-1.id,
                        aws_subnet.public-subnet-2.id]
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.prod-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-target-group.arn
  }
}
    