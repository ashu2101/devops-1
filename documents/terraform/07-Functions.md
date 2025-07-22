# 🧮 7. Functions in Terraform

Terraform provides a wide range of **built-in functions** that help transform, evaluate, and manipulate data within your configurations. In this module, we will cover the most commonly used functions—with **real AWS-focused examples**.

---

## 🧠 Topics Covered

### 📦 Common Built-in Functions (with AWS examples)

#### ✅ `length(list)`

Returns the number of elements in a list.

```hcl
variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

output "total_azs" {
  value = length(var.availability_zones)
}
```

> 🔍 Use this to decide how many subnets or resources to create per AZ.

---

#### ✅ `join(delimiter, list)`

Joins a list of strings using a delimiter.

```hcl
locals {
  tags = ["env:dev", "owner:ashu", "team:infra"]
}

output "csv_tags" {
  value = join(",", local.tags)
}
```

> 🔍 Useful for concatenating tags, IAM ARNs, or comma-separated strings for policies.

---

#### ✅ `lookup(map, key, default)`

Safely look up a value from a map.

```hcl
variable "region_ami_map" {
  default = {
    "us-east-1" = "ami-0c02fb55956c7d316"
    "us-west-2" = "ami-0abcdef1234567890"
  }
}

output "selected_ami" {
  value = lookup(var.region_ami_map, "us-east-1", "ami-default")
}
```

> 🔍 Prevents errors in multi-region deployments when a key might be missing.

---

#### ✅ `merge(map1, map2)`

Combines multiple maps into a single one.

```hcl
locals {
  default_tags = {
    Owner = "Ashu"
  }

  additional_tags = {
    Environment = "dev"
    Project     = "infra"
  }

  all_tags = merge(local.default_tags, local.additional_tags)
}

resource "aws_s3_bucket" "merged_tagged_bucket" {
  bucket = "my-terraform-merged-bucket"
  acl    = "private"
  tags   = local.all_tags
}
```

---

#### ✅ `file(path)`

Reads the content of a file.

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  user_data     = file("${path.module}/scripts/bootstrap.sh")
}
```

> 🔍 Inject startup scripts (e.g., installing Apache) into EC2 instances.

---

#### ✅ `stripspace(string)`

Removes all extra whitespace characters from the string.

```hcl
output "cleaned_name" {
  value = stripspace("  production-server-01   ")
}
```

> 🔍 Useful for sanitizing input from `.tfvars` or file input.

---

### 🔄 Type Conversion Functions

#### ✅ `tostring(any)`

```hcl
output "az_count_string" {
  value = tostring(length(var.availability_zones))
}
```

#### ✅ `tolist(any)`

```hcl
locals {
  az_map = {
    a = "us-east-1a"
    b = "us-east-1b"
  }
}

output "az_list" {
  value = tolist(values(local.az_map))
}
```

#### ✅ `tomap(any)`

```hcl
locals {
  list_of_maps = [
    { name = "A", value = 1 },
    { name = "B", value = 2 }
  ]

  named_map = tomap({ for obj in local.list_of_maps : obj.name => obj.value })
}

output "converted_map" {
  value = local.named_map
}
```

#### ✅ `toset(any)`

```hcl
locals {
  ports = toset([22, 80, 443, 443])
}

output "unique_ports" {
  value = local.ports
}
```

> 🔍 Helps remove duplicates when creating security group rules.

---

### 🕓 Date and Math Functions

#### ✅ `timestamp()`

Returns the current UTC time in RFC 3339 format.

```hcl
output "current_time" {
  value = timestamp()
}
```

#### ✅ `timeadd(timestamp, duration)`

```hcl
output "expiry_time" {
  value = timeadd(timestamp(), "24h")
}
```

> 🔍 Useful for temporary access or time-bound backups.

#### ✅ `floor`, `ceil`, `min`, `max`, `abs`

```hcl
output "max_ec2_instances" {
  value = max(3, 5, 2)
}
```

---

## 🧪 Hands-On: Use Functions in Locals and Outputs

```hcl
variable "env" {
  default = "  dev  "
}

locals {
  clean_env = stripspace(var.env)
  full_tags = merge(
    { Environment = local.clean_env },
    { Team = "DevOps" }
  )
}

resource "aws_s3_bucket" "example" {
  bucket = "terraform-func-${local.clean_env}"
  acl    = "private"
  tags   = local.full_tags
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}

output "timestamped_deployment" {
  value = timestamp()
}
```

---

## 📌 Additional AWS-Based Examples

### 📁 1. Combine Availability Zones with Prefix (using `join`, `for`)

```hcl
variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

output "named_subnets" {
  value = [for az in var.azs : join("-", ["subnet", az])]
}
```

> ➕ Outputs: `["subnet-us-east-1a", "subnet-us-east-1b"]`

---

### 📁 2. Tag Resources Dynamically with `merge`, `lookup`

```hcl
variable "extra_tags" {
  default = {
    Owner = "ashu"
    Env   = "dev"
  }
}

locals {
  base_tags = {
    Project = "TerraformCourse"
  }

  all_tags = merge(local.base_tags, var.extra_tags)
}

resource "aws_s3_bucket" "tagged_bucket" {
  bucket = "terraform-tagged-bucket"
  acl    = "private"
  tags   = local.all_tags
}
```

---

## ✅ Summary

| Function       | Purpose                   |
| -------------- | ------------------------- |
| `length()`     | Count elements in list    |
| `join()`       | Combine strings           |
| `lookup()`     | Safely access map values  |
| `merge()`      | Combine multiple maps     |
| `file()`       | Inject external content   |
| `stripspace()` | Clean strings             |
| `tomap()`      | Convert list → map        |
| `toset()`      | Eliminate duplicates      |
| `timestamp()`  | Time-based automation     |
| Math funcs     | `max`, `min`, `abs`, etc. |

---
