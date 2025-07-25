# variable "env" {
#   type    = string
#   default = "dev"
# }

locals {
  env           = "prod"
  instance_type = "t3.micro"
}
