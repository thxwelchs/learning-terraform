variable "az_list" {
  description = "availability zones"
  type        = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
}