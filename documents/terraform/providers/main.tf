provider "aws" { // Default provider configuration
  region = "ap-south-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "north_virginia" # Name 
}

resource "aws_s3_bucket" "one" {
  bucket = "my-aewsome-buckets0101"
}

resource "aws_s3_bucket" "two" {
  provider = aws.north_virginia
  bucket   = "my-aewsome-buckets0202"
}
