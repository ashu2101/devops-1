variable "env" {
  type        = string
  description = "The environment for which the resources are being created, e.g., 'prod'/ 'dev' / 'ppe'"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the EC2 instance"
  default     = "ami-0b32d400456908bf9"
}

variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to create, e.g., 't2.micro', 't3.medium'"
  default     = "t2.micro"

}

locals {
  ec2_name = "${var.env}-ec2-machine"
}
