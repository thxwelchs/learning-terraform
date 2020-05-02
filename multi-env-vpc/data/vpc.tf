module "vpc" {
  source = "../modules/vpc"

  name = "data"
  cidr = "10.0.3.0/24"

  az_list = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  public_subnets = ["10.0.3.0/27", "10.0.3.32/27", "10.0.3.64/27"]
  private_subnets = ["10.0.3.128/27", "10.0.3.160/27", "10.0.3.192/27"]
  # 96 ~ 127, 224 ~ 255 는 일단 임시로 서브넷팅 안함

  tags = {}
}