resource "aws_key_pair" "dev-instance-key" {
  key_name = "dev-instance-key"
  public_key = file("~/.ssh/dev_ssh_key.pub")
}

resource "aws_instance" "public" {
  count = length(var.public_subnets)

  ami = "ami-01288945bd24ed49a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.dev-instance-key.key_name
  vpc_security_group_ids = [aws_security_group.web_public_sg.id]
  availability_zone = var.az_list[count.index]
  subnet_id = var.public_subnets[count.index]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2-instance-profile.name

  user_data = <<EOF
#cloud-config

packages:
 - docker

runcmd:
 - [ sh, -c, "usermod -aG docker ec2-user" ]
 - [ sh, -c, "usermod -aG docker ssm-user" ]
 - service docker start
 - systemctl enable docker
 - echo 'export ENV_MODE=${var.name}' > ~/my_env.sh
 - echo 'export AWS_DEFAULT_REGION=ap-northeast-2' >> ~/my_env.sh
 - chmod +x ~/my_env.sh
 - cp ~/my_env.sh /etc/profile.d/my_env.sh
 - source /etc/profile.d/my_env.sh
  EOF

  tags = {
    Name = "${var.name}-public-instance"
  }
}

resource "aws_instance" "private" {
  count = length(var.private_subnets)

  ami = "ami-01288945bd24ed49a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.dev-instance-key.key_name
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  availability_zone = var.az_list[count.index]
  subnet_id = var.private_subnets[count.index]
  iam_instance_profile = aws_iam_instance_profile.ec2-instance-profile.name

  user_data = <<EOF
#cloud-config

packages:
 - docker

runcmd:
 - [ sh, -c, "usermod -aG docker ec2-user" ]
 - [ sh, -c, "usermod -aG docker ssm-user" ]
 - service docker start
 - systemctl enable docker
 - echo 'export ENV_MODE=${var.name}' > ~/my_env.sh
 - echo 'export AWS_DEFAULT_REGION=ap-northeast-2' >> ~/my_env.sh
 - chmod +x ~/my_env.sh
 - cp ~/my_env.sh /etc/profile.d/my_env.sh
 - source /etc/profile.d/my_env.sh
  EOF

  tags = {
    Name = "${var.name}-private-instance"
  }
}