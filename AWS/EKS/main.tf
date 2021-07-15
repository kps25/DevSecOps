provider "aws" {
  region = "us-east-1"
}

//*** Create The VPC ***//

resource "aws_vpc" "cluster-ssp-ninja" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "10.0.0.0/20"
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "false"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name = "cluster-ssp-ninja"
  }

  tags_all = {
    Name = "cluster-ssp-ninja"
  }
}

//*** Create The Subnets ***//

resource "aws_subnet" "cluster-ssp-ninja-subnet-a" {
  vpc_id     = aws_vpc.cluster-ssp-ninja.id
  cidr_block = "10.0.0.0/22"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "cluster-ssp-ninja-subnet-a"
  }
}

resource "aws_subnet" "cluster-ssp-ninja-subnet-b" {
  vpc_id     = aws_vpc.cluster-ssp-ninja.id
  cidr_block = "10.0.4.0/22"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "cluster-ssp-ninja-subnet-b"
  }
}

# resource "aws_subnet" "cluster-ssp-ninja-subnet-c" {
#   vpc_id     = aws_vpc.cluster-ssp-ninja.id
#   cidr_block = "10.0.8.0/22"
#   availability_zone = "us-east-1c"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "cluster-ssp-ninja-subnet-c"
#   }
# }

# resource "aws_subnet" "cluster-ssp-ninja-subnet-d" {
#   vpc_id     = aws_vpc.cluster-ssp-ninja.id
#   cidr_block = "10.0.12.0/22"
#   availability_zone = "us-east-1d"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "cluster-ssp-ninja-subnet-d"
#   }
# }

//*** Create The Internet Gateway ***//

resource "aws_internet_gateway" "cluster-ssp-ninja-ig" {
  vpc_id = aws_vpc.cluster-ssp-ninja.id

  tags = {
    Name = "cluster-ssp-ninja-ig"
  }
}

//*** Add the Route Table Entry for gateway traffic. ***//

resource "aws_route" "cluster-ssp-ninja-ig-route" {
  route_table_id            = aws_vpc.cluster-ssp-ninja.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.cluster-ssp-ninja-ig.id
}

//*** Allocate the elastic IP's ***//

resource "aws_eip" "cluster-ssp-ninja-eip-a" {
  vpc      = true
  tags = {
    Name = "cluster-ssp-ninja-eip-a"
  }
}

resource "aws_eip" "cluster-ssp-ninja-eip-b" {
  vpc      = true
  tags = {
    Name = "cluster-ssp-ninja-eip-b"
  }
}

# resource "aws_eip" "cluster-ssp-ninja-eip-c" {
#   vpc      = true
#   tags = {
#     Name = "cluster-ssp-ninja-eip-c"
#   }
# }

# resource "aws_eip" "cluster-ssp-ninja-eip-d" {
#   vpc      = true
#   tags = {
#     Name = "cluster-ssp-ninja-eip-d"
#   }
# }

//*** Create the NAT Gateways ***///

resource "aws_nat_gateway" "cluster-ssp-ninja-ng-a" {
  allocation_id = aws_eip.cluster-ssp-ninja-eip-a.id
  subnet_id     = aws_subnet.cluster-ssp-ninja-subnet-a.id

  tags = {
    Name = "cluster-ssp-ninja-ng-a"
  }

  depends_on = [aws_internet_gateway.cluster-ssp-ninja-ig]
}

resource "aws_nat_gateway" "cluster-ssp-ninja-ng-b" {
  allocation_id = aws_eip.cluster-ssp-ninja-eip-b.id
  subnet_id     = aws_subnet.cluster-ssp-ninja-subnet-b.id

  tags = {
    Name = "cluster-ssp-ninja-ng-b"
  }

  depends_on = [aws_internet_gateway.cluster-ssp-ninja-ig]
}

# resource "aws_nat_gateway" "cluster-ssp-ninja-ng-c" {
#   allocation_id = aws_eip.cluster-ssp-ninja-eip-c.id
#   subnet_id     = aws_subnet.cluster-ssp-ninja-subnet-c.id

#   tags = {
#     Name = "cluster-ssp-ninja-ng-c"
#   }

#   depends_on = [aws_internet_gateway.cluster-ssp-ninja-ig]
# }

# resource "aws_nat_gateway" "cluster-ssp-ninja-ng-d" {
#   allocation_id = aws_eip.cluster-ssp-ninja-eip-d.id
#   subnet_id     = aws_subnet.cluster-ssp-ninja-subnet-d.id

#   tags = {
#     Name = "cluster-ssp-ninja-ng-d"
#   }

#   depends_on = [aws_internet_gateway.cluster-ssp-ninja-ig]
# }

//***********************************************************************************************//

//*** Create the EKS Cluster IAM Policies ***//

resource "aws_iam_role" "cluster-ssp-ninja-eks-role" {
  name = "cluster-ssp-ninja-eks-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster-ssp-ninja-eks-role-pa" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-ssp-ninja-eks-role.name
}

//*** Create the EKS Cluster ***//

resource "aws_eks_cluster" "cluster-ssp-ninja" {
  name     = "cluster"
  role_arn = aws_iam_role.cluster-ssp-ninja-eks-role.arn
  enabled_cluster_log_types = ["audit", "authenticator", "api", "controllerManager", "scheduler"]

  tags = {
    eks-cluster = "cluster-ssp-ninja"
  }

  tags_all = {
    eks-cluster = "cluster-ssp-ninja"
  }

  version = "1.20"

  vpc_config {
    endpoint_private_access = "false"
    endpoint_public_access  = "true"
    public_access_cidrs     = ["0.0.0.0/0"]
    # subnet_ids = [aws_subnet.cluster-ssp-ninja-subnet-a.id, aws_subnet.cluster-ssp-ninja-subnet-b.id, aws_subnet.cluster-ssp-ninja-subnet-c.id, aws_subnet.cluster-ssp-ninja-subnet-d.id]
    subnet_ids = [aws_subnet.cluster-ssp-ninja-subnet-a.id, aws_subnet.cluster-ssp-ninja-subnet-b.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-ssp-ninja-eks-role-pa
  ]
}

//*** Create The Node Groups ***//

resource "aws_iam_role" "cluster-ssp-ninja-node-group-role" {
  name = "cluster-ssp-ninja-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "cluster-ssp-ninja-node-group-role-pa-1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.cluster-ssp-ninja-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "cluster-ssp-ninja-node-group-role-pa-2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.cluster-ssp-ninja-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "cluster-ssp-ninja-node-group-role-pa-3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.cluster-ssp-ninja-node-group-role.name
}

resource "tls_private_key" "cluster-ssp-ninja-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "cluster-ssp-ninja-kp" {
  key_name   = "cluster-ssp-ninja-kp"
  public_key = tls_private_key.cluster-ssp-ninja-key.public_key_openssh
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.cluster-ssp-ninja.name
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  # instance_types  = ["m5.large"]
  instance_types  = ["t2.small"]
  node_group_name = "cluster-ssp-ninja-ng"
  node_role_arn   = aws_iam_role.cluster-ssp-ninja-node-group-role.arn
#   subnet_ids      = [aws_subnet.cluster-ssp-ninja-subnet-a.id, aws_subnet.cluster-ssp-ninja-subnet-b.id, aws_subnet.cluster-ssp-ninja-subnet-c.id, aws_subnet.cluster-ssp-ninja-subnet-d.id]
  subnet_ids      = [aws_subnet.cluster-ssp-ninja-subnet-a.id, aws_subnet.cluster-ssp-ninja-subnet-b.id]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key = aws_key_pair.cluster-ssp-ninja-kp.key_name
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-ssp-ninja-node-group-role-pa-1,
    aws_iam_role_policy_attachment.cluster-ssp-ninja-node-group-role-pa-2,
    aws_iam_role_policy_attachment.cluster-ssp-ninja-node-group-role-pa-3,
  ]
}