resource "tls_private_key" "cloud2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cloud2_key" {
  key_name   = "cloud2"
  public_key = tls_private_key.cloud2_private_key.public_key_openssh
}

resource "local_file" "cloud2_pem" {
  filename        = "${path.root}/keys/cloud2Key.pem"
  content         = tls_private_key.cloud2_private_key.private_key_pem
  file_permission = "0400"
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

resource "aws_instance" "ec2_public_1" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_1_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  key_name                    = aws_key_pair.cloud2_key.key_name
  user_data                   = var.ec2_user_data

  tags = {
    Name = "EC2 Specialization 1"
  }
}

resource "aws_instance" "ec2_public_2" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_2_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  key_name                    = aws_key_pair.cloud2_key.key_name
  user_data                   = var.ec2_user_data

  tags = {
    Name = "EC2 Specialization 2"
  }
}

resource "aws_security_group" "allow_ssh" {
  count = 0
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id
}

output "ec2_public_1_ip" {
  value = aws_instance.ec2_public_1.public_ip
}

output "ec2_public_2_ip" {
  value = aws_instance.ec2_public_2.public_ip
}