## General
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "azeem-aws"
    key    = "dev/vpc-subnet.tfstate"
  }
}