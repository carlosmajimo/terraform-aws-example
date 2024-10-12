variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
}

variable "public_subnet_1_id" {}
variable "public_subnet_2_id" {}
variable "private_subnet_1_id" {}
variable "private_subnet_2_id" {}