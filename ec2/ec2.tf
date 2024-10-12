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
  user_data                   = <<-EOF
                                ${var.ec2_user_data}
                                echo '<html><body><h1>Esta es la EC2 1</h1></body></html>' | docker exec -i my-nginx tee /usr/share/nginx/html/index.html
                                EOF

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
  user_data                   = <<-EOF
                                ${var.ec2_user_data}
                                echo '<html><body><h1>Esta es la EC2 2</h1></body></html>' | docker exec -i my-nginx tee /usr/share/nginx/html/index.html
                                EOF

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

output "ec2_security_group_id" {
  value = aws_security_group.allow_ssh_http.id
}

resource "aws_security_group" "alb_sg" {
  name        = "allow_http_alb"
  description = "Allow HTTP inbound traffic for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
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
    Name = "allow_http_alb"
  }
}

resource "aws_security_group_rule" "allow_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.allow_ssh_http.id
}

resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  tags = {
    Name = "Web ALB"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "ec2_1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.ec2_public_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ec2_2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.ec2_public_2.id
  port             = 80
}

output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}