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

  lifecycle {
    prevent_destroy = false // Prevent accidental deletion
  }
}


resource "aws_s3_bucket" "bucket-2" {
  // 2nd resource block
  bucket = "terraform-created-awesomebucket" // Unique bucket name

  tags = {
    createdBy   = "Terraform"
    environment = "dev"
  }
} // Terraform will create this bucket


data "aws_s3_bucket" "existing_bucket" {
  bucket = "my-app-s3-25-06"
} // Data source block to reference an existing S3 bucket


resource "aws_s3_bucket_policy" "existing_bucket_policy" {
  bucket = data.aws_s3_bucket.existing_bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["118497224894"]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      data.aws_s3_bucket.existing_bucket.arn,
      "${data.aws_s3_bucket.existing_bucket.arn}/*",
    ]
  }
}


# .aws> cat .\credentials
# [default]
# aws_access_key_id = 
# aws_secret_access_key = 


// id : terraform-created-bucket-1507
// arn : arn:aws:s3:::terraform-created-awesomebucket
// Metadata / History for the S3 buckets
// TF --> .tfstate file --> aws resurces create 


// What is difference between a resource and a data source in Terraform?
// A resource is a component of your infrastructure that Terraform manages, such as an S3 bucket
// A data source is a read-only view of existing infrastructure that Terraform can query, such as an existing S3 bucket or IAM policy
// Resources are created, modified, and deleted by Terraform, while data sources are used to retrieve information about existing resources without making changes to them
// Resources are defined in the configuration files, while data sources are typically used to reference existing resources
