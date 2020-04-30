variable "name" {
  description = "module environment prefix"
  type        = string
}

variable "public_subnets" {
  type        = list(string)
}

variable "private_subnets" {
  type        = list(string)
}

variable "az_list" {
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc id"
}