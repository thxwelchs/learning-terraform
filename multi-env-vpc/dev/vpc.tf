module "vpc" {
  source = "../modules/vpc"

  name = "dev"
  cidr = "10.0.0.0/24"

  az_list = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  public_subnets = ["10.0.0.0/27"]
  private_subnets = ["10.0.0.128/27"]
//  public_subnets = ["10.0.0.0/27", "10.0.0.32/27", "10.0.0.64/27"]
//  private_subnets = ["10.0.0.128/27", "10.0.0.160/27", "10.0.0.192/27"]
  # 96 ~ 127, 224 ~ 255 는 일단 임시로 서브넷팅 안함

  tags = {}
}