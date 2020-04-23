resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
      Name = "dev-vpc"
  }
}


resource "aws_default_route_table" "dev-default-rt" {
  default_route_table_id = "${aws_vpc.dev-vpc.default_route_table_id}"

  tags = {
    Name = "dev-default-rt"
  }
}

resource "aws_route_table" "dev-public-rt" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev-igw.id}"
  }

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route_table" "dev-private-rt" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dev-nat.id}"
  }

  tags = {
    Name = "dev-private-rt"
  }
}

resource "aws_internet_gateway" "dev-igw" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  tags = {
      Name = "dev-igw"
  }
}

resource "aws_eip" "dev-nat-eip" {
  vpc = true
  tags = {
      Name = "dev-nat-eip"
  }
}
resource "aws_nat_gateway" "dev-nat" {
  allocation_id = "${aws_eip.dev-nat-eip.id}"
  subnet_id     = "${aws_subnet.dev-public-subnet-a.id}"
  tags = {
      Name = "dev-nat"
  }
}

// public zone subnet 생성
resource "aws_subnet" "dev-public-subnet-a" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.0.0.0/27"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "dev-public-subnet-a"
  }
}
resource "aws_subnet" "dev-public-subnet-b" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.0.0.32/27"
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "dev-public-subnet-b"
  }
}
resource "aws_subnet" "dev-public-subnet-c" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.0.0.64/27"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "dev-public-subnet-c"
  }
}

// private zone subnet 생성
resource "aws_subnet" "dev-private-subnet-a" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.0.0.128/27"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "dev-private-subnet-a"
  }
}

resource "aws_subnet" "dev-private-subnet-b" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.0.0.160/27"
  availability_zone = "ap-northeast-2b"
  tags = {
    Name = "dev-private-subnet-b"
  }
}

resource "aws_subnet" "dev-private-subnet-c" {
  vpc_id = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.0.0.192/27"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "dev-private-subnet-c"
  }
}

resource "aws_route_table_association" "association-public-a" {
  subnet_id = "${aws_subnet.dev-public-subnet-a.id}"
  route_table_id = "${aws_route_table.dev-public-rt.id}"
}

resource "aws_route_table_association" "association-public-b" {
  subnet_id = "${aws_subnet.dev-public-subnet-b.id}"
  route_table_id = "${aws_route_table.dev-public-rt.id}"
}

resource "aws_route_table_association" "association-public-c" {
  subnet_id = "${aws_subnet.dev-public-subnet-c.id}"
  route_table_id = "${aws_route_table.dev-public-rt.id}"
}
resource "aws_route_table_association" "association-private-a" {
  subnet_id = "${aws_subnet.dev-private-subnet-a.id}"
  route_table_id = "${aws_route_table.dev-private-rt.id}"
}
resource "aws_route_table_association" "association-private-b" {
  subnet_id = "${aws_subnet.dev-private-subnet-b.id}"
  route_table_id = "${aws_route_table.dev-private-rt.id}"
}
resource "aws_route_table_association" "association-private-c" {
  subnet_id = "${aws_subnet.dev-private-subnet-c.id}"
  route_table_id = "${aws_route_table.dev-private-rt.id}"
}