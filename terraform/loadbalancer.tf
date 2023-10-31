resource "aws_lb" "freenow_alb" {
  depends_on         = [aws_instance.freenow_ec2]
  name               = "FreeNow-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.freenow_subnet : subnet.id]
  security_groups    = [aws_security_group.freenow_alb_sg.id]
  tags = {
    Name = "freenow-alb"
  }
}

resource "aws_lb_listener" "freenow_alb_listener" {
  load_balancer_arn = aws_lb.freenow_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.freenow_target_group.arn
  }
}

resource "aws_alb_target_group" "freenow_target_group" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.freenow_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  depends_on = [aws_lb.freenow_alb]
}

resource "aws_alb_target_group_attachment" "freenow_target_attachment" {
  target_group_arn = aws_alb_target_group.freenow_target_group.arn
  target_id        = aws_instance.freenow_ec2.id
}
