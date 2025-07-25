variable "env" {
  type        = string
  description = "value of environment for which the resources are being created, e.g., 'prod'/ 'dev' / 'ppe'"
}

locals {
  bucket_names = "${var.env}-terraform-modules-bucket-28-07"
}
