data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# 동적 포트매핑, SSH sg
resource "aws_security_group" "ecs_dynamic-mapping-sg" {
  name = "${var.name}-ecs-dynamic-mapping-sg"
  description = "ecs_dynamic-mapping-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
}

# ECS 동적 포트매핑 인바운드 범위 허용 (ECS 클러스터 ALB 보안그룹이 적용된 리소스에게만 )
resource "aws_security_group_rule" "ecs_dynamic_mapping_rule" {
  description = "ecs-dynamic-mapping-rule"
  from_port = 32768
  protocol = "tcp"
  security_group_id = aws_security_group.ecs_dynamic-mapping-sg.id
  source_security_group_id = aws_security_group.ecs_cluster_alb-sg.id
  to_port = 65535
  type = "ingress"
}

# ECS 클러스터 ALB 보안 그룹
resource "aws_security_group" "ecs_cluster_alb-sg" {
  vpc_id = var.vpc_id
  description = "ecs-cluster-alb-sg"
  name = "${var.name}-ecs-cluster-alb-sg"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS 클러스터 ALB 보안그룹 모든트래픽 outbound (ECS 클러스터 내 보안그룹이 적용된 리소스에게만 )
resource "aws_security_group_rule" "ecs_cluster-alb-outbound_rule" {
  description = "ecs_cluster-alb-outbound_rule"
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.ecs_cluster_alb-sg.id
  source_security_group_id = aws_security_group.ecs_dynamic-mapping-sg.id
  to_port = 0
  type = "egress"
}