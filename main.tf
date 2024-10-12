provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./vpc"
  
  region = var.region
  vpc_cidr = var.vpc_cidr
  cluster_name       = var.cluster_name
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
}

# module "gateway" {
#   source = "./gateway"
#   vpc_id = module.vpc.vpc_id
#   public_subnet_1_id = module.vpc.public_subnet_1_id
#   public_subnet_2_id = module.vpc.public_subnet_2_id
# }

# module "ec2" {
#   source = "./ec2"
#   vpc_id = module.vpc.vpc_id
#   public_subnet_1_id = module.vpc.public_subnet_1_id
#   public_subnet_2_id = module.vpc.public_subnet_2_id
#   ami_id = var.ami_id
#   ec2_user_data = var.ec2_user_data
# }
# 
# module "rds" {
#   source = "./rds"
#   vpc_id = module.vpc.vpc_id
#   ec2_security_group_id = module.ec2.ec2_security_group_id
#   private_subnet_1_id = module.vpc.private_subnet_1_id
#   private_subnet_2_id = module.vpc.private_subnet_2_id
# }

module "eks" {
  source = "./eks"

  cluster_name       = var.cluster_name
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
}