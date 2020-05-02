data "aws_route53_zone" "this" {
  name = "${var.dns}."
}

resource "aws_route53_record" "web" {
  type = "A"
  zone_id = data.aws_route53_zone.this.zone_id
  name = "${var.name != "prod" ? var.name : ""}${var.name != "prod" ? "-" : ""}web.${data.aws_route53_zone.this.name}"

  alias {
    evaluate_target_health = false
    name = aws_alb.this.dns_name
    zone_id = aws_alb.this.zone_id
  }
}

resource "aws_route53_record" "api" {
  name = "${var.name != "prod" ? var.name : ""}${var.name != "prod" ? "-" : ""}api.${data.aws_route53_zone.this.name}"
  type = "CNAME"
  zone_id = data.aws_route53_zone.this.zone_id
  ttl = "300"

  records = ["${var.name != "prod" ? var.name : ""}${var.name != "prod" ? "-" : ""}web.${data.aws_route53_zone.this.name}"]

}