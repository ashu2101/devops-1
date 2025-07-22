# 🔁 6. Control Structures in Terraform

Terraform’s control structures like `count`, `for_each`, and `for` expressions allow us to build **dynamic**, **parameterized**, and **repeatable** infrastructure with minimal code. This lesson explores these features in-depth with **real AWS Free Tier-compatible examples**.

---

## 🧠 Topics Covered

- `count` (in-depth)
- `for_each` (in-depth)
- `count` vs `for_each`
- Conditional resource creation
- `for` expressions in `locals`, `outputs`, and `dynamic` blocks
- Practical AWS Free Tier examples

---

## 🔢 `count`: Create N Copies of a Resource

`count` is used to create multiple identical (or similar) instances of a resource based on a numeric value.

### 🔧 Use Case: Launching 2 EC2 Instances

```hcl
resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "web-${count.index}"
  }
}
```

> ✅ This creates 2 Free Tier EC2 instances with distinct names: `web-0`, `web-1`.

---

## 🧾 `for_each`: Iterate Over Maps or Sets of Strings

`for_each` is used when creating multiple resources with different values or identifiers.

### 📦 Use Case: Create Multiple S3 Buckets with Different Names

```hcl
variable "bucket_names" {
  type = list(string)
  default = ["dev-bucket", "test-bucket"]
}

resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names)

  bucket = each.key
  acl    = "private"
  tags = {
    Name = each.key
  }
}
```

> ✅ This creates two uniquely named S3 buckets, one for dev and one for test.

---

## 🔁 `count` vs `for_each`: When to Use What?

| Feature  | `count`                         | `for_each`                        |
| -------- | ------------------------------- | --------------------------------- |
| Type     | Integer                         | Map or Set of strings             |
| Use When | Creating N copies of a resource | Creating distinct named resources |
| Indexing | `count.index`                   | `each.key`, `each.value`          |
| Best For | Homogeneous resources           | Heterogeneous resources           |

---

## ❓ Conditional Resources with `count`

Use a ternary conditional to enable or disable a resource dynamically.

### ⚡ Use Case: Conditionally Create an EC2 Instance

```hcl
variable "enable_instance" {
  type    = bool
  default = true
}

resource "aws_instance" "optional_ec2" {
  count         = var.enable_instance ? 1 : 0
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "ConditionalEC2"
  }
}
```

> ✅ This resource will only be created if `enable_instance = true`.

---

## 🔁 Loops in `locals`, `outputs`, and `dynamic` Blocks

### 🧮 `locals` with `for`

```hcl
variable "names" {
  default = ["dev", "test", "prod"]
}

locals {
  name_tags = [for name in var.names : "env-${name}"]
}
```

> Creates a local list like `["env-dev", "env-test", "env-prod"]`.

---

### 📤 `output` with `for` Expression

```hcl
output "formatted_names" {
  value = [for name in var.names : upper(name)]
}
```

> Outputs: `["DEV", "TEST", "PROD"]`

---

### 🔄 `dynamic` Blocks with Looping

Use `dynamic` for generating nested arguments (e.g., ingress rules in a security group).

#### 🔐 Use Case: Dynamic Security Group Rules

```hcl
variable "allowed_ports" {
  default = [22, 80, 443]
}

resource "aws_security_group" "web_sg" {
  name = "web-sg"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

> ✅ This will dynamically create multiple ingress rules in one resource block.

---

## 🧪 Full Hands-On: Mixed Example with EC2 and S3

### 🎯 Goal

- Conditionally create 1 EC2 instance
- Create multiple S3 buckets from a list
- Tag resources dynamically

### 📁 `main.tf`

```hcl
variable "enable_ec2" {
  default = true
}

variable "bucket_names" {
  default = ["infra-logs", "terraform-state"]
}

resource "aws_instance" "conditional_ec2" {
  count         = var.enable_ec2 ? 1 : 0
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "ControlledEC2"
  }
}

resource "aws_s3_bucket" "project_buckets" {
  for_each = toset(var.bucket_names)

  bucket = each.key
  acl    = "private"

  tags = {
    Environment = each.key
  }
}
```

---

## ✅ Summary

| Feature               | Description                                      |
| --------------------- | ------------------------------------------------ |
| `count`               | Creates N similar resources                      |
| `for_each`            | Iterates over a set/map to create unique items   |
| Conditional resources | Controlled by boolean variables                  |
| `for` expressions     | Used in `locals`, `output`, and `dynamic` blocks |
| AWS Use Cases         | EC2, S3, Security Group rules                    |

---
