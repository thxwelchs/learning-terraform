resource "aws_ssm_parameter" "backend_repo_url" {
  name        = "/${var.name}/backend_repo_url"
  description = "ECR backend_repo_url"
  type        = "String"
  value       = aws_ecr_repository.backend.repository_url
}

resource "aws_ssm_parameter" "frontend_repo_url" {
  name        = "/${var.name}/frontend_repo_url"
  description = "ECR frontend_repo_url"
  type        = "String"
  value       = aws_ecr_repository.frontend.repository_url
}