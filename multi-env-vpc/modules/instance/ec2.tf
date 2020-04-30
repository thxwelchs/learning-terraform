resource "aws_key_pair" "dev-instance-key" {
  key_name = "dev-instance-key"
  public_key = file("~/.ssh/dev_ssh_key.pub")
}

resource "aws_instance" "public" {
  count = length(var.public_subnets)

  ami = "ami-01288945bd24ed49a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.dev-instance-key.key_name
  vpc_security_group_ids = []
  availability_zone = var.az_list[count.index]
  subnet_id = var.public_subnets[count.index]

  user_data = <<EOF
sudo amazon-linux-extras install docker -y
sudo usermod -aG docker ec2-user
sudo systemctl enable docker
sudo systemctl start docker
  EOF

  tags {
    Name = "${var.name}-public-instance"
  }
}

resource "aws_instance" "private" {
  count = length(var.private_subnets)

  ami = "ami-01288945bd24ed49a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.dev-instance-key.key_name
  vpc_security_group_ids = []
  availability_zone = var.az_list[count.index]
  subnet_id = var.private_subnets[count.index]

  user_data = <<EOF
sudo amazon-linux-extras install docker -y
sudo usermod -aG docker ec2-user
sudo systemctl enable docker
sudo systemctl start docker
  EOF

  tags {
    Name = "${var.name}-private-instance"
  }
}