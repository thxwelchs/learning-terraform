variable "public_subnets_cidr" {
    type = "list"
    default = ["10.0.0.0/27", "10.0.0.32/27", "10.0.0.64/27"]
}

variable "private_subnets_cidr" {
    type = "list"
    default = ["10.0.0.128/27", "10.0.0.160/27", "10.0.0.192/27"]
}