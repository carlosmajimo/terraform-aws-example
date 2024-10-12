resource "aws_internet_gateway" "cloud2_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Specialization IGW"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud2_igw.id
  }

  tags = {
    Name = "Public Specialization Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_1_route" {
  subnet_id      = var.public_subnet_1_id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_route" {
  subnet_id      = var.public_subnet_2_id
  route_table_id = aws_route_table.public_route_table.id
}