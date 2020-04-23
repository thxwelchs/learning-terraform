resource "aws_vpc" "this" {
  cidr_block = var.cidr

  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    Name = "${var.name}-default-rt"
  }
}

resource "aws_route_table" "this_public_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table" "this_private_rt" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_eip" "this" {
  vpc = true
  tags = {
    Name = "${var.name}-nat-eip"
  }
}
# AZ 모두 생성하는게 맞지만, 그냥 A 한개만 생성
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public.0.id
  tags = {
    Name = "${var.name}-nat"
  }
}

# public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.az_list[count.index]

  tags = {
    Name = "${var.name}-public-${substr(var.az_list[count.index], length(var.az_list[count.index])-2, length(var.az_list[count.index])-1)}"
  }
}

# private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.az_list[count.index]

  tags = {
    Name = "${var.name}-private-${substr(var.az_list[count.index], length(var.az_list[count.index])-2, length(var.az_list[count.index])-1)}"
  }
}

# route table association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.this_public_rt.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.this_private_rt.id
}
