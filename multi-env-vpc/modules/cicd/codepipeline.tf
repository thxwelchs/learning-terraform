resource "aws_codepipeline" "this" {
  name = "${var.name}-pipeline"
  role_arn = aws_iam_role.codebuild_role.arn
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
        Owner                = "thxwelchs"
        Repo                 = "learning-terraform"
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
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeploy"
      input_artifacts = ["BuildArtifact"]
      version = "1"
      configuration = {
        ApplicationName = aws_codedeploy_app.this.name
        DeploymentGroupName = aws_codedeploy_deployment_group.this.deployment_group_name
      }
    }
  }


}

data "aws_ssm_parameter" "github_token" {
  name = "github_token"
}