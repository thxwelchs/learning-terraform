data "aws_canonical_user_id" "current" {}

output "canonical_user_id" {
  value = data.aws_canonical_user_id.current.id
}

output "ecr_backend_repo_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_frontend_repo_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "s3_bucket" {
  value = aws_s3_bucket.this.bucket
}