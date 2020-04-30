variable "name" {
  description = "module environment prefix"
  type        = string
}

variable "az_list" {
  description = "availability zones"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "frontend_port" {
  type = number
  default = 80
}

variable "backend_port" {
  type = number
  default = 8080
}