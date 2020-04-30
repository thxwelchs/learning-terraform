resource "aws_alb" "ecs_alb" {
  name = "${var.name}-ecs-alb"
  security_groups = [aws_security_group.ecs_cluster_alb-sg.id]
//  subnets = concat(var.public_subnets, var.private_subnets)
  subnets = var.public_subnets

  tags = {
    Name = "${var.name}-ecs-alb"
  }
}

resource "aws_alb_target_group" "ecs_frontend_tg" {
  name = "${var.name}-ecs-frontend-tg"
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

  depends_on = [aws_alb.ecs_alb]

  tags = {
    Name = "${var.name}-ecs-frontend-tg"
  }
}

resource "aws_alb_target_group" "ecs_backend_tg" {
  name = "${var.name}-ecs-backend-tg"
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

  depends_on = [aws_alb.ecs_alb]

  tags = {
    Name = "${var.name}-ecs-backend-tg"
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ecs_frontend_tg.arn
  }
}

resource "aws_alb_listener_rule" "alb-backend-rule" {
  listener_arn = aws_alb_listener.alb-listener.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ecs_backend_tg.arn
  }

//  condition {
//    field  = "host-header"
//    values = ["some.host.name"]
//  }
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
