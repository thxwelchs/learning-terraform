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
