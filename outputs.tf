output "public_subnet_1_id" {
  value = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  value = module.vpc.public_subnet_2_id
}

output "ec2_public_1_ip" {
  value = module.ec2.ec2_public_1_ip
}

output "ec2_public_2_ip" {
  value = module.ec2.ec2_public_2_ip
}