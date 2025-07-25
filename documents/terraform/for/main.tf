
variable "names" {
  type    = list(string)
  default = ["dev", "test", "prod"]
}

locals {
  name_tags = [for name in var.names : "env-${name}"]
}


output "name_tags" {
  value = local.name_tags
}
