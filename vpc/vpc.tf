# vpc/vpc.tf

resource "aws_vpc" "cloud2_vpc" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = "Specialization VPC"
  }
}

resource "aws_subnet" "public_cloud2_vpc_subnet_1" {
  vpc_id     = aws_vpc.cloud2_vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "Public Specialization Subnet 1"
  }
}

resource "aws_subnet" "public_cloud2_vpc_subnet_2" {
  vpc_id     = aws_vpc.cloud2_vpc.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "Public Specialization Subnet 2"
  }
}

resource "aws_subnet" "private_cloud2_vpc_subnet_1" {
  vpc_id     = aws_vpc.cloud2_vpc.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "Private Specialization Subnet 1"
  }
}

resource "aws_subnet" "private_cloud2_vpc_subnet_2" {
  vpc_id     = aws_vpc.cloud2_vpc.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "Private Specialization Subnet 2"
  }
}

output "vpc_id" {
  value = aws_vpc.cloud2_vpc.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public_cloud2_vpc_subnet_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_cloud2_vpc_subnet_2.id
}