variable "vpc_id" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "public_subnet_1_id" {
  description = "Id of subnet one"
  default     = ""
}

variable "public_subnet_2_id" {
  description = "Id of subnet two"
  default     = ""
}
variable "ami_id" {
  description = "The AMI ID to use for EC2 instances"
  default     = "ami-0fff1b9a61dec8a5f"
}

variable "ec2_user_data" {
  description = "User data command to execute"
  default     = <<-EOF
                EOF
}