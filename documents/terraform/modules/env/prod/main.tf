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

module "ec2" {
  source        = "../../module-1"
  env           = local.env
  instance_type = local.instance_type
}

module "s3" {
  source = "../../module-2"
  env    = local.env
}

output "instance_id" {
  value = module.ec2.ec2_instance_id
}
