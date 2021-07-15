terraform {
  backend "s3" {
    bucket = "azeem-aws"
    key    = "eks_cluster_tf"
    region = "us-east-1"
  }
}