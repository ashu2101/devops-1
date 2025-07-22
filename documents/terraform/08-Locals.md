# 🧷 8. Locals in Terraform

`locals` in Terraform allow you to define intermediate values or computed expressions to simplify and organize your configuration. They're especially useful when working with complex expressions, derived data, or shared logic across modules.

---

## 🧠 Topics Covered

### ✅ Syntax of `locals`

```hcl
locals {
  environment = "dev"
  project     = "myapp"
  region      = "us-east-1"
}
```

> You can access a local like this: `local.environment`

---

## 🔍 Use Cases for `locals`

| Use Case            | Example                                                   |
| ------------------- | --------------------------------------------------------- |
| Avoiding repetition | Reuse commonly used values like region, environment, tags |
| Derived values      | Create dynamic values using expressions and functions     |
| Complex logic       | Use loops and conditionals in one place                   |
| Cleaner code        | Abstract expressions for readability                      |

---

### 🧾 Example: Simplifying AWS Resource Configuration

```hcl
locals {
  instance_type = "t2.micro"
  name_prefix   = "terraform-lab"
  full_name     = "${local.name_prefix}-${terraform.workspace}"
}

resource "aws_instance" "example" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = local.instance_type

  tags = {
    Name = local.full_name
  }
}
```

> 🧼 Cleaner than repeating `"t2.micro"` or `terraform.workspace` everywhere.

---

## 🆚 Variables vs Locals

| Feature      | `variable`                       | `local`                                          |
| ------------ | -------------------------------- | ------------------------------------------------ |
| Used For     | Accepting user or external input | Internal derived/computed values                 |
| Can override | Yes (via CLI, env, tfvars, etc.) | No – locals are fixed once defined in the config |
| Scope        | Module                           | Module                                           |
| Best For     | User-configurable input          | Computed logic, constants, or derived values     |

### 🔄 When to Use Which?

- Use **`variable`** when:

  - You expect the value to be overridden
  - The value is different across environments

- Use **`local`** when:

  - You want to simplify complex expressions
  - You don’t need external input or overriding

---

## 🔗 Combine Locals with Functions & Expressions

### 🧮 Example: Derived Tags and Naming

```hcl
variable "environment" {
  default = "dev"
}

variable "project" {
  default = "terraform-course"
}

locals {
  name_suffix = "${var.project}-${var.environment}"
  tags = merge({
    Project     = var.project,
    Environment = var.environment
  }, {
    Owner = "ashu"
  })
}

resource "aws_s3_bucket" "example" {
  bucket = "bucket-${local.name_suffix}"
  acl    = "private"
  tags   = local.tags
}
```

---

## 🧪 Hands-On: Locals with Logic

### 🎯 Create EC2 instance with dynamic name and tags

```hcl
variable "environment" {
  default = "prod"
}

locals {
  instance_name = "web-${var.environment}"
  tags = {
    Environment = var.environment
    CreatedBy   = "Terraform"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  tags = merge(local.tags, {
    Name = local.instance_name
  })
}
```

---

## ✅ Summary

| Concept    | Description                                          |
| ---------- | ---------------------------------------------------- |
| `locals`   | Define internal values for expressions or formatting |
| Use case   | Code clarity, logic reuse, no need for override      |
| Use with   | Functions, loops, merge(), concat, etc.              |
| Difference | Locals are fixed; variables are meant for input      |

---
