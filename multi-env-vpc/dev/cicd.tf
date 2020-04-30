module "cicd" {
  source = "../modules/cicd"
  name = "dev"
  ecr_frontend_repo_url = module.instance.ecr_frontend_repo_url
  ecr_backend_repo_url = module.instance.ecr_backend_repo_url

  ecs_cluster_name = module.instance.ecs_cluster_name
  ecs_frontend_service_name = module.instance.ecs_frontend_service_name
  ecs_backend_service_name = module.instance.ecs_backend_service_name

}
