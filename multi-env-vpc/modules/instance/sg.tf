data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# public SG (22, 443, 80 인바운드 허용)
resource "aws_security_group" "web_public_sg" {
  name = "web-public-sg"
  description = "ecs_dynamic-mapping-sg"
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

}

# private SG public SG로부터만 인바운드 허용
resource "aws_security_group" "private_sg" {
  vpc_id = var.vpc_id
  description = "private-sg"
  name = "${var.name}-private-sg"
}

resource "aws_security_group_rule" "only-public-sg-ingress-rule" {
  description = "only-public-sg-ingress-rule"
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.web_public_sg.id
  to_port = 0
  type = "ingress"
}