output "ecr_frontend_repo_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "ecr_backend_repo_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_frontend_service_name" {
  value = aws_ecs_service.ecs_frontend_service.name
}

output "ecs_backend_service_name" {
  value = aws_ecs_service.ecs_backend_service.name
}