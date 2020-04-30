module "instance" {
  source = "../modules/instance"
  name = "dev"

  az_list = var.az_list
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets_ids
  private_subnets = module.vpc.private_subnets_ids
}
