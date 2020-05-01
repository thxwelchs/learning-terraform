resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codedeploy.amazonaws.com",
          "codepipeline.amazonaws.com",
          "s3.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: "logs:*",
        Resource: "*"
      },
      {
        Effect: "Allow",
        Resource: aws_codebuild_project.project.id
        Action: [
          "autoscaling:*",
          "codebuild:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "iam:*",
          "logs:*",
          "rds:DescribeDBInstances",
          "route53:*",
          "s3:*",
          "codedeploy:*",
          "ecr:*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name       = "codebuild-policy-attachment"
  policy_arn = aws_iam_policy.codebuild_policy.arn
  roles      = [aws_iam_role.codebuild_role.id]
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com",
          "codedeploy.amazonaws.com",
          "codepipeline.amazonaws.com",
          "s3.amazonaws.com"
        ]
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "codepipeline-policy"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodePipeline"

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "sns:*",
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplicationRevision",
          "codedeploy:RegisterApplicationRevision",
          "s3:*",
          "codedeploy:GetDeploymentConfig",
          "cloudformation:*",
          "elasticloadbalancing:*",
          "servicecatalog:CreateProvisioningArtifact",
          "autoscaling:*",
          "codebuild:BatchGetBuilds",
          "servicecatalog:ListProvisioningArtifacts",
          "servicecatalog:DeleteProvisioningArtifact",
          "cloudwatch:*",
          "servicecatalog:UpdateProduct",
          "codedeploy:GetDeployment",
          "ecs:*",
          "ecr:DescribeImages",
          "ec2:*",
          "servicecatalog:DescribeProvisioningArtifact",
          "codebuild:StartBuild",
          "codedeploy:GetApplication",
          "cloudformation:ValidateTemplate"
        ],
        Resource: "*"
      },
      {
        Effect: "Allow",
        Action: "iam:PassRole",
        Resource: "*",
        Condition: {
          StringEqualsIfExists: {
            "iam:PassedToService": [
              "cloudformation.amazonaws.com",
              "elasticbeanstalk.amazonaws.com",
              "ec2.amazonaws.com",
              "ecs-tasks.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "codepipeline_policy_attachment" {
  name       = "codepipeline_policy_attachment-policy-attachment"
  policy_arn = aws_iam_policy.codepipeline_policy.arn
  roles      = [aws_iam_role.codepipeline_role.id]
}