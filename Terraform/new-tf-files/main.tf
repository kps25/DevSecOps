
resource "aws_vpc" "new-vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tfstate-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.new-vpc.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "tfstate-subnet"
  }
}
