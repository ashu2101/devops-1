variable "instance_name" {
  type = string
  # default     = "my-instance"
  description = "Name of the EC2 instance"
}

variable "tags" {
  type = map(string)
  # default = {
  #   Environment = "dev"
  #   Owner       = "mark"
  # }
}


variable "ports" {
  type = list(number)
  # default = [22, 80, 443]
}
