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

variable "ec2_instance_iam_policies" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}