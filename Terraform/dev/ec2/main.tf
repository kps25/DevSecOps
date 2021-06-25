provider "aws" {
    region = "us-east-1"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = "azeem-ec2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaABancL0f9E2hcBt9HYvVDjdbIMSfpTJcNq7LjRTjCDbwfpaLSVibiQk74MMNiEWKM3z1dh7lFqh4M//uMS4x4rtErUHEbqeqMbkL+2/Kr6kqyAQ0JGyxsbCDf7z4acB42KU+pTzGTZB2TTbqegGbN/QMZ/EfvMl6LMNligkOHmGmHzYOj8MXHSrEvbMRTTWamDIqJ6LvAwTf0g/pZCLvohfGkOK9V2HGF4Ro9xHB83/z6+H2bV8XU0e88ze4qpT0FIfulrzAPVEKVuDyyPz6dsi2hm47/84h+B8vmTO7dzrX4dD5AHf9D7w0DC0vrKycDqQ1nFeN/9gltrmzgHQsE1NkrSXHHxkkd7jsnDox09d0C3HR5RWF90HFal4TF/mUYPL9CYdAmf/n4Nl3it0bqSsgIycJT4JNyyu+5wMjhgEZbhl4szk+6K/RsBRHiQDRREB+EZNnwv6ZUJHwNFeR8paDKQWSmhcJhPfgqHo4Nx7b7ZXwk6LGCSzj0s8YDys= sasalugu@MBP-SHIVA.SALUG"

}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "azeem-sg"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = "vpc-0db5dd5e044ea4790"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "http"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "azeem-cluster"
  instance_count         = 2

  ami                    = "ami-0747bdcabd34c712a"
  instance_type          = "t2.micro"
  key_name               = "azeem-ec2"
  associate_public_ip_address = true
  monitoring             = false
#   vpc_id                 = "vpc-09c2c37150032d3d6"
  vpc_security_group_ids   = [module.security_group.security_group_id]
  subnet_id                = "subnet-0a37686e36651dd41"
  user_data                = "${file("install-apache.sh")}"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}