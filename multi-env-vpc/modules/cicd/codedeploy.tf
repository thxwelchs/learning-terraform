resource "aws_iam_role" "codedeploy_role" {
  name = "${var.name}-codedeploy-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy_role.name
}


resource "aws_codedeploy_app" "this" {
  name = "${var.name}-cd"
  compute_platform = "Server"
}

resource "aws_codedeploy_deployment_group" "this" {
  app_name = aws_codedeploy_app.this.name
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name = "${var.name}-cdg"
  service_role_arn = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type = "IN_PLACE"
  }

  ec2_tag_set {
    ec2_tag_filter {
      key = "Name"
      type = "KEY_AND_VALUE"
      value = "${var.name}-webserver"
    }
  }

  auto_rollback_configuration {
    enabled = false
  }
}