variable "ami_id" {}

variable "instance" {
    default = "t2.micro"
}

variable "key_pair" {}

variable "sg_id" {}

variable "subnet_id" {}

variable "pub_ip_want" {
  default = "true"
}

variable "name" {
    default = "instance" 
}