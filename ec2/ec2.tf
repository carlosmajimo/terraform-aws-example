resource "tls_private_key" "cloud2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cloud2_key" {
  key_name   = "cloud2"
  public_key = tls_private_key.cloud2_private_key.public_key_openssh
}

resource "local_file" "cloud2_pem" {
  filename = "${path.module}/cloud2.pem"
  content  = tls_private_key.cloud2_private_key.private_key_pem
  file_permission = "0400"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_ssh"
  }
}

resource "aws_instance" "ec2_public_1" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_1_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name      = aws_key_pair.cloud2_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "EC2 Specialization 1"
  }
}

resource "aws_instance" "ec2_public_2" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_2_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name      = aws_key_pair.cloud2_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "EC2 Specialization 2"
  }
}

output "ec2_public_1_ip" {
  value = aws_instance.ec2_public_1.public_ip
}

output "ec2_public_2_ip" {
  value = aws_instance.ec2_public_2.public_ip
}