terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch the default security group for that VPC
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# Fetch all subnets in the default VPC
//Define
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Launch the EC2 instance in the first available subnet
resource "aws_instance" "free_tier" {
  # ami                    = "ami-0a1235697f4afa8a4"
  # instance_type          = "t2.micro"             
  ami                    = var.amazon_ec2_ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = data.aws_subnets.existing.ids[1] # ["subnet-0c9c18080e1e61e3e", "subnet-07b0645eaaeb9e82a", "subnet-01b16bafa005087ae"]
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = local.instance_name
  }
}
