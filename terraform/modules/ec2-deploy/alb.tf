resource "aws_lb" "alb" {
  name               = "${var.service_name}-alb"
  internal           = var.is_private
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.is_private ? data.aws_subnet_ids.private_subnet_ids.ids : data.aws_subnet_ids.public_subnet_ids.ids
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_listener" "alb_http_listener" {
  count             = var.strict_https ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "listerner_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
  condition {
    host_header {
      values = ["${var.service_name}.${var.domain_root}"]
    }
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "${var.service_name}-target-group"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  health_check {
    path                = var.health_check_path
    port                = var.target_port
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 2
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "${var.service_name}_lb_sg"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.service_name}_lb_sg"
  }
}
