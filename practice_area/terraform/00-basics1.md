✅ Creates a VPC
✅ Defines a default Security Group (local)
✅ Accepts a user-defined SG via module input
✅ Accepts instance type and validates it against allowed types
✅ Uses `count` to deploy multiple EC2 instances **only if the instance type is valid**

---

## 📁 Project Structure

```
ec2-deployment/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── provider.tf
└── modules/
    └── ec2_module/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
```

---

### ✅ Root Module

---

### 🔹 `provider.tf`

```hcl
provider "aws" {
  region = var.region
}
```

---

### 🔹 `variables.tf`

```hcl
variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to launch"
}

variable "count" {
  type        = number
  description = "Number of EC2 instances to create"
}

variable "custom_sg_id" {
  type        = string
  description = "User-defined security group ID"
}
```

---

### 🔹 `main.tf`

```hcl
module "ec2" {
  source         = "./modules/ec2_module"
  instance_type  = var.instance_type
  ec2_count      = var.count
  custom_sg_id   = var.custom_sg_id
}
```

---

### 🔹 `terraform.tfvars`

```hcl
instance_type = "t2.micro"
count         = 2
custom_sg_id  = "sg-0123456789abcdef0"  # Replace with real SG ID or use another module
```

---

## 📦 Module: `modules/ec2_module/`

---

### 🔹 `variables.tf`

```hcl
variable "instance_type" {
  type        = string
  description = "Requested EC2 instance type"
}

variable "ec2_count" {
  type        = number
  description = "Number of EC2 instances"
}

variable "custom_sg_id" {
  type        = string
  description = "External user-defined security group ID"
}

locals {
  allowed_instance_types = ["t2.micro", "t3.micro", "t2.small"]

  is_instance_allowed = contains(local.allowed_instance_types, var.instance_type)
}
```

---

### 🔹 `main.tf`

```hcl
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "custom-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
}

resource "aws_security_group" "default_sg" {
  name        = "default-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  count = local.is_instance_allowed ? var.ec2_count : 0

  ami                    = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [
    aws_security_group.default_sg.id,
    var.custom_sg_id
  ]
  associate_public_ip_address = true

  tags = {
    Name = "ValidatedEC2-${count.index + 1}"
  }
}
```

---

### 🔹 `outputs.tf`

```hcl
output "ec2_instance_ids" {
  value = aws_instance.ec2[*].id
  description = "IDs of created EC2 instances"
}

output "ec2_public_ips" {
  value = aws_instance.ec2[*].public_ip
}
```

---

## ✅ Summary of Logic

| Feature                | Implementation                                      |
| ---------------------- | --------------------------------------------------- |
| Default SG             | Created inside the module                           |
| Custom SG              | Passed as variable `custom_sg_id`                   |
| Allowed instance types | Checked using `contains()` in `locals` block        |
| Conditional creation   | `count = local.is_instance_allowed ? var.count : 0` |
| Multiple EC2s          | Created using `count`                               |

---

## 🔍 Optional Enhancements

- Replace custom SG ID with a **nested module** to create it
- Replace instance type list with **`validation` blocks** (Terraform >= 0.13)
- Add **CloudWatch logging**, **user_data scripts**, or **Elastic IP**

---
