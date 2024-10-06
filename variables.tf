variable "region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "30.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  default     = "30.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  default     = "30.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  default     = "30.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  default     = "30.0.4.0/24"
}


variable "ec2_user_data" {
  description = "User data command to execute"
  default     = <<-EOF
                  #!/bin/bash

                  yum update -y
                  yum install -y docker
                  systemctl start docker
                  systemctl enable docker
                  docker run -d -p 80:80 --name my-nginx nginx
                EOF
}

variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  default     = "ami-0fff1b9a61dec8a5f"
}