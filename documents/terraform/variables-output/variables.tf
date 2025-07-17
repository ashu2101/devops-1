variable "amazon_ec2_ami_id" {
  description = "This virable will be used to specify the Amazon EC2 AMI ID for the instance."
  type        = string
  #   default     = "ami-0a1235697f4afa8a4" # Example AMI ID, replace with a valid one
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro" # Free tier eligible instance type
}

variable "no_of_instances" {
  type    = number
  default = 2
}


# name  = "ashu"                         // String
# age   = 30                             // number / Interger 
# skils = ["python", "terraform", "aws"] // List of strings
# map = {
#   key1 = "value1"
#   key2 = "value2"
# } // Map of strings
