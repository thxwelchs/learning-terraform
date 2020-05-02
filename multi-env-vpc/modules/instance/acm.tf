data "aws_acm_certificate" "this" {
  domain = "*.${var.dns}"
}