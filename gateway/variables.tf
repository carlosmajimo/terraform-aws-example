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