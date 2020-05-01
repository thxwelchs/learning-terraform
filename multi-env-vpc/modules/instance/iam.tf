resource "aws_iam_role" "ec2-role" {
  name                = "ec2-instance-role"
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-instance-role-attachment" {
  count = length(var.ec2_instance_iam_policies)
  role       = aws_iam_role.ec2-role.name
  policy_arn = var.ec2_instance_iam_policies[count.index]
}


resource "aws_iam_instance_profile" "ec2-instance-profile" {
  name = "ec2-instance-profile"
  path = "/"
  role = aws_iam_role.ec2-role.name
}