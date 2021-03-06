resource "aws_key_pair" "dev-instance-key" {
  key_name = "dev-instance-key"
  public_key = file("~/.ssh/dev_ssh_key.pub")
}

resource "aws_instance" "public" {
//  count = length(var.public_subnets)
  count = 1

  ami = "ami-01288945bd24ed49a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.dev-instance-key.key_name
  vpc_security_group_ids = [aws_security_group.instance_public_sg.id]
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
 - yum install -y jq ruby aws-cli
 - systemctl enable docker
 - wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
 - chmod +x ./install
 - ./install auto
 - mkdir ~/.aws && printf "[default]\nregion=ap-northeast-2" > ~/.aws/config
 - mkdir /home/ec2-user/.aws && printf "[default]\nregion=ap-northeast-2" > /home/ec2-user/.aws/config
 - echo 'export ENV_MODE=${var.name}' > ~/my_env.sh
 - echo '{"ENV_MODE":"${var.name}","DEPLOY_TYPE":"frontend"}' > ~/my_env.json
 - chmod +x ~/my_env.sh
 - cp ~/my_env.sh /etc/profile.d/my_env.sh
 - cp ~/my_env.json /etc/profile.d/my_env.json
  EOF

  tags = {
    Name = "${var.name}-public-instance"
  }
}

resource "aws_instance" "private" {
  count = 1
//  count = length(var.private_subnets)

  ami = "ami-01288945bd24ed49a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.dev-instance-key.key_name
  vpc_security_group_ids = [aws_security_group.instance_private_sg.id]
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
 - yum install -y jq ruby aws-cli
 - systemctl enable docker
 - wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
 - chmod +x ./install
 - ./install auto
 - mkdir ~/.aws && printf "[default]\nregion=ap-northeast-2" > ~/.aws/config
 - mkdir /home/ec2-user/.aws && printf "[default]\nregion=ap-northeast-2" > /home/ec2-user/.aws/config
 - echo 'export ENV_MODE=${var.name}' > ~/my_env.sh
 - echo '{"ENV_MODE":"${var.name}","DEPLOY_TYPE":"backend"}' > ~/my_env.json
 - chmod +x ~/my_env.sh
 - cp ~/my_env.sh /etc/profile.d/my_env.sh
 - cp ~/my_env.json /etc/profile.d/my_env.json
  EOF

  tags = {
    Name = "${var.name}-private-instance"
  }
}