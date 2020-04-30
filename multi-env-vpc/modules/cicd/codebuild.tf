data "aws_region" "current" {}

resource "aws_codebuild_project" "project" {
  name          = "${var.name}-ci"
  description   = "${var.name} CodeBuild Project"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:2.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name = "ENV_NAME"
      value = var.name
    }

    environment_variable {
      name = "AWS_DEFAULT_REGION"
      value = data.aws_region.current.name
    }

    environment_variable {
      name = "BACKEND_IMAGE_REPO_URL"
      value = var.ecr_backend_repo_url
    }

    environment_variable {
      name = "FRONTEND_IMAGE_REPO_URL"
      value = var.ecr_frontend_repo_url
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "multi-env-vpc/buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}