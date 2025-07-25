resource "aws_instance" "web" {
  ami           = "ami-0b32d400456908bf9"
  instance_type = "t2.micro"
  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}

# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }
# provider "aws" {
#   region = "ap-south-1"
# }
