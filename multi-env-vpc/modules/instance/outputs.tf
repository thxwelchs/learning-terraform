output "nameservers" {
  description = "ns list"
  value = data.aws_route53_zone.this.name_servers
}