terraform {
  // {} Blocks
  // Configures the Terraform backend and required providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1" // AWS region
}

// Resource blocks define the infrastructure components
// Example: Create an S3 bucket
resource "aws_s3_bucket" "bucket-1" {
  // 1st resrource block
  bucket = "terraform-created-bucket-1507" // Unique bucket name

  tags = {
    createdBy   = "Terraform" // update ~
    environment = "dev"       //add + 
  }
}


resource "aws_s3_bucket" "bucket-2" {
  // 2nd resource block
  bucket = "terraform-created-awesomebucket" // Unique bucket name

  tags = {
    createdBy   = "Terraform"
    environment = "dev"
  }
}



# .aws> cat .\credentials
# [default]
# aws_access_key_id = 
# aws_secret_access_key = 
