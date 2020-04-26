resource "aws_s3_bucket" "this" {
  bucket = "thxwelchs-artifacts"
  acl = "private"
}