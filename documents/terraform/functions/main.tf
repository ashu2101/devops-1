# variable "availability_zones" {
#   default = ["us-east-1a", "us-east-1b", "us-east-1c", "ap-south-1a", "ap-south-1b"]
# }

# output "total_cou" {
#   value = length(var.availability_zones)
# }

# locals {
#   tags = ["env:dev", "owner:ashu", "team:infra"]
# }

# output "csv_tags" {
#   value = join("----", local.tags)
# }

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "ap-south-1a", "ap-south-1b", "us-east-1a"]
}
output "az_count_string" {
  value = toset(var.availability_zones)
}
