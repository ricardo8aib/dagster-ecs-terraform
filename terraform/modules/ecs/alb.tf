# ALB
resource "aws_lb" "webserver_load_balancer" {
  name               = var.WEBSERVER_ALB_NAME
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.ALB_SECURITY_GROUP]
  subnets            = var.SUBNET_IDS_FOR_ALB

  enable_deletion_protection = false
}

# Target group
resource "aws_lb_target_group" "webserver_target_group" {
  name        = var.ALB_TARGET_GROUP_NAME
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.VPC_ID
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

# ALB Listener
resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.webserver_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_target_group.arn
  }
}
