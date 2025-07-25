# variable "bucket_names" {
#   type    = list(string)
#   default = ["devops-classes-dev-bucket", "devops-classes-test-bucket"]
# }

# resource "aws_s3_bucket" "buckets" {
#   for_each = toset(var.bucket_names) //  ["devops-classes-dev-bucket", "devops-classes-test-bucket"]

#   bucket = each.key
#   tags = {
#     Name = each.key
#   }
# }

variable "ec2_instance_names" {
  type    = list(string)
  default = ["First-ec2", "Second-ec2"]
}

resource "aws_instance" "web" {
  for_each = toset(var.ec2_instance_names) // ["First-ec2", "Second-ec2"]\

  ami           = "ami-0b32d400456908bf9"
  instance_type = "t2.micro"

  tags = {
    Name = each.key
  }
}
