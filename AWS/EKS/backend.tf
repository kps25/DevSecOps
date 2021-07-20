terraform {
  backend "s3" {
    bucket = "azeem-aws"
    key    = "tf_state/eks_cluste_tf"
    region = "us-east-1"
  }
}