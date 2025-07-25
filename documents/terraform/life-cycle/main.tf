resource "aws_s3_bucket" "my_bucket" {
  bucket = "life-cycle-demo-bucket-2027"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    # ignore_changes = [
    #   tags["Name"],
    # ]
  }
}
