

terraform {
  backend "s3" {
    bucket = "azeem-aws"
    key    = "dev/ec2.tfstate"
    region = "us-east-1"
  }
}