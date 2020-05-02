data "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket
}

resource "aws_alb" "this" {
  name = "${var.name}-alb"
  security_groups = [aws_security_group.alb_web_public_sg.id]
  //  subnets = concat(var.public_subnets, var.private_subnets)
  subnets = var.public_subnets

  access_logs {
    bucket = data.aws_s3_bucket.bucket.bucket
    prefix = "logs"
    enabled = true
  }

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_alb_target_group" "frontend_tg" {
  name = "${var.name}-frontend-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/healthz"
    healthy_threshold = 5
    unhealthy_threshold = 2
    matcher = "200"
    interval = 30
    timeout = 5
    enabled = true
    port = "traffic-port"
    protocol = "HTTP"
  }

  tags = {
    Name = "${var.name}-frontend-tg"
  }
}

resource "aws_alb_target_group" "backend_tg" {
  name = "${var.name}-backend-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/api/healthz"
    healthy_threshold = 5
    unhealthy_threshold = 2
    matcher = "200"
    interval = 30
    timeout = 5
    enabled = true
    port = "traffic-port"
    protocol = "HTTP"
  }

  depends_on = [aws_alb.this]

  tags = {
    Name = "${var.name}-ecs-backend-tg"
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.this.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.frontend_tg.arn
  }
}

resource "aws_alb_listener" "alb-listener-ssl" {
  load_balancer_arn = aws_alb.this.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.this.arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.frontend_tg.arn
  }
}

resource "aws_alb_listener_rule" "alb-frontend-rule" {
  count = 2
  listener_arn = count.index == 0 ? aws_alb_listener.alb-listener.arn : aws_alb_listener.alb-listener-ssl.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.frontend_tg.arn
  }

  condition {
    host_header {
      values = ["${var.name != "prod" ? var.name : ""}${var.name != "prod" ? "-" : ""}web.${var.dns}"]
    }
  }
}

resource "aws_alb_listener_rule" "alb-backend-rule" {
  count = 2
  listener_arn = count.index == 0 ? aws_alb_listener.alb-listener.arn : aws_alb_listener.alb-listener-ssl.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.backend_tg.arn
  }

  condition {
    host_header {
      values = ["${var.name != "prod" ? var.name : ""}${var.name != "prod" ? "-" : ""}api.${var.dns}"]
    }
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

resource "aws_alb_target_group_attachment" "frontend_tg_attachment" {
  count = length(aws_instance.public)
  target_group_arn = aws_alb_target_group.frontend_tg.arn
  target_id = aws_instance.public[count.index].id
  port = 3030
}

resource "aws_alb_target_group_attachment" "backend_tg_attachment" {
  count = length(aws_instance.private)
  target_group_arn = aws_alb_target_group.backend_tg.arn
  target_id = aws_instance.private[count.index].id
  port = 8080
}


