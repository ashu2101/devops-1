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

resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names) # ["tf-create-buckket-1", "tf-create-buckket-2", "tf-create-buckket-3"]
  bucket   = each.value              #  each.key / each.value
}


# resource "aws_s3_bucket" "buckets" {

#   for_each = tomap(var.bucket_vs_region) # ["tf-create-buckket-1", "tf-create-buckket-2", "tf-create-buckket-3"]
#   bucket   = each.key                    #  each.key = bucket name
#   region   = each.value                  #  each.value = region
# }
