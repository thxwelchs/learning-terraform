data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}


resource "aws_security_group" "instance_public_sg" {
  name = "instance-public-sg"
  description = "instance-public-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "only-instance-public-sg-ingress-rule" {
  description = "only-instance-public-sg-ingress-rule"
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.instance_public_sg.id
  source_security_group_id = aws_security_group.alb_web_public_sg.id
  to_port = 0
  type = "ingress"
}


# public SG (22, 443, 80 인바운드 허용) ALB에 적용
resource "aws_security_group" "alb_web_public_sg" {
  name = "alb-web-public-sg"
  description = "alb-web-public-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# private SG public SG로부터만 인바운드 허용
resource "aws_security_group" "instance_private_sg" {
  vpc_id = var.vpc_id
  description = "instance-private-sg"
  name = "instance-private-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "private-sg-only-alb-ingress-rule" {
  description = "private-sg-only-alb-ingress-rule"
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.instance_private_sg.id
  source_security_group_id = aws_security_group.alb_web_public_sg.id
  to_port = 0
  type = "ingress"
}

resource "aws_security_group_rule" "private-sg-only-public-instance-ingress-rule" {
  description = "private-sg-only-public-instance-ingress-rule"
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.instance_private_sg.id
  source_security_group_id = aws_security_group.instance_public_sg.id
  to_port = 0
  type = "ingress"
}