resource "aws_key_pair" "this" {
  key_name = "${var.name}-instance-key"
  public_key = file("~/.ssh/${var.name}_ssh_key.pub")
}


# ECS Load Balaning OR ECS Service에서 사용할 Role
# 이게 ECS Service Task들간의 LB(health check, ingress, ec2 describe 등) Role임
resource "aws_iam_role" "ecs-service-role" {
  name                = "ecs-service-role"
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# ECS AutoScaling Group 구성에서 생성 한 EC2 Resource에 적용 할 Role
# 이게 ecs cluster도 생성하고, ecs service 안에 있는 task들에게 ecr 이미지도 배포하고 등을 담당하는 Role
resource "aws_iam_role" "ecs-instance-role" {
  name                = "ecs-instance-role"
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# ASG configuration에서 사용할 iam profile
resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role.id
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.name}-ecs-cluster"
}

data "aws_ecs_task_definition" "frontend" {
  task_definition = aws_ecs_task_definition.frontend_task_definition.family
}

resource "aws_ecs_task_definition" "frontend_task_definition" {
  family = "frontend"
  container_definitions = <<DEFINITION
[
    {
        "name": "frontend",
        "image": "${aws_ecr_repository.frontend.repository_url}",
        "cpu": 0,
        "memory": 128,
        "memoryReservation": 128,
        "portMappings": [
            {
                "containerPort": ${var.frontend_port},
                "hostPort": 0,
                "protocol": "tcp"
            }
        ],
        "essential": true,
        "environment": [],
        "mountPoints": [],
        "volumesFrom": []
    }
]
DEFINITION
}

data "aws_ecs_task_definition" "backend" {
  task_definition = aws_ecs_task_definition.backend_task_definition.family
}

resource "aws_ecs_task_definition" "backend_task_definition" {
  family = "backend"
  container_definitions = <<DEFINITION
[
    {
        "name": "backend",
        "image": "${aws_ecr_repository.backend.repository_url}",
        "cpu": 0,
        "memory": 128,
        "memoryReservation": 128,
        "portMappings": [
            {
                "containerPort": ${var.backend_port},
                "hostPort": 0,
                "protocol": "tcp"
            }
        ],
        "essential": true,
        "environment": [],
        "mountPoints": [],
        "volumesFrom": []
    }
]
DEFINITION
}

resource "aws_ecs_service" "ecs_frontend_service" {
  name = "frontend"
  iam_role = aws_iam_role.ecs-service-role.name
  cluster = aws_ecs_cluster.this.id
  task_definition = "${aws_ecs_task_definition.frontend_task_definition.family}:${max(aws_ecs_task_definition.frontend_task_definition.revision, data.aws_ecs_task_definition.frontend.revision)}"
  desired_count = 1
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_frontend_tg.arn
    container_name = "frontend"
    container_port = var.frontend_port
  }

}

resource "aws_ecs_service" "ecs_backend_service" {
  name = "backend"
  iam_role = aws_iam_role.ecs-service-role.name
  cluster = aws_ecs_cluster.this.id
  task_definition = "${aws_ecs_task_definition.backend_task_definition.family}:${max(aws_ecs_task_definition.backend_task_definition.revision, data.aws_ecs_task_definition.backend.revision)}"
  desired_count = 1
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_backend_tg.arn
    container_name = "backend"
    container_port = var.backend_port
  }

  depends_on = [aws_alb_listener_rule.alb-backend-rule]
}