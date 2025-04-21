resource "aws_lb_target_group" "prod-target-group" {
  name     = "prod-ec2-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id


  target_health_state {
    enable_unhealthy_connection_termination = false
  }
}

resource "aws_lb_target_group_attachment" "attach_1" {
  target_group_arn = aws_lb_target_group.prod-target-group.arn
  target_id        = aws_instance.prod-my-instance-1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach_2" {
  target_group_arn = aws_lb_target_group.prod-target-group.arn
  target_id        = aws_instance.prod-my-instance-2.id
  port             = 80
}