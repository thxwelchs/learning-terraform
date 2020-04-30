resource "aws_ecr_repository" "backend" {
  name = "${var.name}/backend"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "frontend" {
  name = "${var.name}/frontend"
  image_tag_mutability = "MUTABLE"
}