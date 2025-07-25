# variable "env" {
#   type    = string
#   default = "dev"
# }

locals {
  env           = "dev"
  instance_type = "t3.micro"
}
