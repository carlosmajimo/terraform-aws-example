variable "vpc_id" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "private_subnet_1_id" {
  description = "Id of subnet one"
  default     = ""
}

variable "private_subnet_2_id" {
  description = "Id of subnet two"
  default     = ""
}

variable "ec2_security_group_id" {
  description = "Security Group of ec2"
  default = ""
}