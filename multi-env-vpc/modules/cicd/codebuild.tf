resource "aws_codebuild_project" "project" {
  name          = "${var.name}-ci"
  description   = "${var.name} CodeBuild Project"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild_role.arn

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "multi-env-vpc/buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}