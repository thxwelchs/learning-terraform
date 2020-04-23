variable "name" {
  description = "module environment prefix"
  type        = string
}

variable "cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnets" {
  description = "Public Subnet CIDR list"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnet CIDR list"
  type        = list(string)
}

variable "az_list" {
  description = "availability zones"
  type        = list(string)
}

variable "tags" {
  description = "resource tag map"
  type        = map(string)
}