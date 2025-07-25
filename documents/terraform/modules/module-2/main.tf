resource "aws_s3_bucket" "buckets" {

  bucket = local.bucket_names
  tags = {
    Name = local.bucket_names
  }
}
