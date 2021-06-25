
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-azeem"
  cidr = "192.168.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["192.168.1.0/24"]
  public_subnets  = ["192.168.100.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  instance_tenancy = "default"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}