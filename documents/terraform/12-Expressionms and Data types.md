# 🧠 12. Expressions and Data Types (Major v1.12 Update)

Terraform v1.12 introduced major enhancements in expression evaluation and data type support. These changes made configurations more expressive, modular, and dynamic.

---

## 📚 Topics Covered

### 🔤 Dynamic Types

Terraform v1.12 added support for complex data types:

#### `object` Type

```hcl
variable "db_config" {
  type = object({
    name     = string
    port     = number
    enabled  = bool
  })
}
```

#### `tuple` Type

```hcl
variable "user_info" {
  type = tuple([string, number, bool])
}
```

#### `any` Type

A flexible type that allows any value:

```hcl
variable "flexible_input" {
  type = any
}
```

---

### 🔁 Complex Expressions

You can write powerful expressions using Terraform’s built-in functions and control structures.

#### `for` Loops (List Transformations)

```hcl
output "bucket_names" {
  value = [for name in var.names : "${name}-bucket"]
}
```

#### `if` Conditionals (Inline Filters)

```hcl
output "active_names" {
  value = [for n in var.users : n if n.enabled]
}
```

#### Common Functions

- `length(list)` – returns number of items
- `merge(map1, map2)` – merges maps
- `lookup(map, key, default)` – safe map access

---

### ❓ Conditional Expressions

```hcl
output "env_type" {
  value = var.is_prod ? "production" : "development"
}
```

Useful for toggling between resource configurations or environments.

---

### ✨ Splat Expressions (`*` operator)

Use `[*]` to extract a field from every item in a list of complex objects:

```hcl
output "instance_ids" {
  value = aws_instance.web[*].id
}
```

This is shorthand for a `for` loop across resources.

---

### ⚙️ Dynamic Blocks

`dynamic` blocks allow you to generate nested blocks programmatically, such as adding multiple security group rules:

```hcl
resource "aws_security_group" "example" {
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
}
```

---

## 🧪 Hands-On: Dynamic S3 Buckets from List of Maps

### 🎯 Goal

- Input a list of bucket definitions
- Create multiple S3 buckets using `for_each`

### 📁 Example Setup

#### `variables.tf`

```hcl
variable "s3_buckets" {
  type = list(object({
    name = string
    acl  = string
  }))
}
```

#### `main.tf`

```hcl
resource "aws_s3_bucket" "buckets" {
  for_each = {
    for bucket in var.s3_buckets : bucket.name => bucket
  }

  bucket = each.key
  acl    = each.value.acl

  tags = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}
```

#### `terraform.tfvars`

```hcl
s3_buckets = [
  {
    name = "bucket-1-terraform"
    acl  = "private"
  },
  {
    name = "bucket-2-terraform"
    acl  = "public-read"
  }
]
```

---

## ▶️ Commands to Run

```bash
terraform init
terraform plan
terraform apply
```

You’ll see multiple S3 buckets being created dynamically based on your list input.

---

## ✅ Summary

| Concept            | Example / Usage                               |
| ------------------ | --------------------------------------------- |
| Complex types      | `object`, `tuple`, `any`                      |
| Expressions        | `for`, `if`, `merge`, `lookup`, `length()`    |
| Conditional logic  | `is_prod ? A : B`                             |
| Splat operator     | `aws_instance.web[*].id`                      |
| Dynamic blocks     | `dynamic \"ingress\"` in `aws_security_group` |
| Resource iteration | `for_each`, `count`                           |

---
