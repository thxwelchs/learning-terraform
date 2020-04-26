resource "aws_codebuild_project" "project" {
  name          = "${var.name}-ci"
  description   = "${var.name} CodeBuild Project"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"
    environment_variable {
      name = "ENV_NAME"
      value = var.name
    }

    environment_variable {
      name = "BACKEND_IMAGE_REPO_URL"
      value = aws_ecr_repository.backend.repository_url
    }

    environment_variable {
      name = "FRONTEND_IMAGE_REPO_URL"
      value = aws_ecr_repository.frontend.repository_url
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