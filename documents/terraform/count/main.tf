resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0b32d400456908bf9"
  instance_type = "t2.micro"

  tags = {
    Name = "web-${count.index + 1}"
  }
}

# count = [1, 2, 3]
# count.index = [0, 1 ,2]


///////////////////////////////////////////////////////////////
## Production and Development Environments

variable "env" {
  type    = string
  default = "prod"
}

resource "aws_instance" "optional_ec2" {
  count         = var.env == "prod" ? 1 : 0
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "ConditionalEC2"
  }
}

// < Condition (True / False) >  ? <TRUE PART will be executed> : <FALSE PART will be executed>
