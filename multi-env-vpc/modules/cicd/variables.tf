variable "name" {
  description = "module environment prefix"
  type        = string
}

variable "github_repo" {
  description = "github repository name"
  type        = string
  default = "learning-terraform"
}

variable "github_ower" {
  description = "github owener name"
  type        = string
  default = "thxwelchs"
}

variable "ecr_frontend_repo_url" {
  type = string
}

variable "ecr_backend_repo_url" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_frontend_service_name" {
  type = string
}

variable "ecs_backend_service_name" {
  type = string
}

