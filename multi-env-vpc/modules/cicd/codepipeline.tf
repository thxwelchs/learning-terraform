resource "aws_codepipeline" "this" {
  name = "${var.name}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  artifact_store {
    location = aws_s3_bucket.this.id
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Owner                = var.github_ower
        Repo                 = var.github_repo
        PollForSourceChanges = "false"
        Branch               = var.name == "prod" ? "master" : var.name
        OAuthToken           = data.aws_ssm_parameter.github_token.value
      }
    }
  }

  stage {
    name = "Build"
    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      output_artifacts = ["BuildArtifact"]
      input_artifacts = ["SourceArtifact"]
      version = "1"
      configuration = {
        ProjectName = aws_codebuild_project.project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Frontend-Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ECS"
      input_artifacts = ["BuildArtifact"]
      version = "1"
      configuration = {
        ClusterName = var.ecs_cluster_name
        FileName = "imagedefinitions-frontend.json"
        ServiceName = var.ecs_frontend_service_name
      }
    }

    action {
      name = "Backend-Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ECS"
      input_artifacts = ["BuildArtifact"]
      version = "1"
      configuration = {
        ClusterName = var.ecs_cluster_name
        FileName = "imagedefinitions-backend.json"
        ServiceName = var.ecs_backend_service_name
      }
    }
  }
}

data "aws_ssm_parameter" "github_token" {
  name = "github_token"
}