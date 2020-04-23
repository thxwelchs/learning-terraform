module "vpc" {
  source = "../modules/vpc"

  name = "prod"
  cidr = "10.0.1.0/24"

  az_list = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  public_subnets = ["10.0.1.0/27", "10.0.1.32/27", "10.0.1.64/27"]
  private_subnets = ["10.0.1.128/27", "10.0.1.160/27", "10.0.1.192/27"]
  # 96 ~ 127, 224 ~ 255 는 일단 임시로 서브넷팅 안함

  tags = {}
}