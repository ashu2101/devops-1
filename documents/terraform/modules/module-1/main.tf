
# EC2 machine ceratetion module

resource "aws_instance" "ec2-machine" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = local.ec2_name
  }
}
