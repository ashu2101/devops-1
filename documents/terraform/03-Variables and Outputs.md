## 🔤 3. Variables and Outputs

This lesson explores one of the most important features of Terraform—**variables and outputs**—which allow us to write reusable, maintainable, and dynamic infrastructure as code.

---

### 🧠 Topics Covered

#### ✅ `variable` Block

Terraform allows you to define variables to parameterize your configurations:

```hcl
variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The type of EC2 instance to launch"
}
```

Each variable can include:

- `type`: Declares the expected type (`string`, `number`, `bool`, `list`, `map`, `object`, `tuple`)
- `default`: A fallback value if no other value is provided
- `description`: Documentation for your variable

---

#### 🆕 New Variable Types in v1.12

Terraform 1.12 introduced powerful new type capabilities:

##### 📦 Object Type

```hcl
variable "db_config" {
  type = object({
    name     = string
    port     = number
    enabled  = bool
  })
}
```

##### 🧮 Tuple Type

Tuples are ordered collections of mixed types:

```hcl
variable "mixed_values" {
  type = tuple([string, number, bool])
}
```

##### 💡 Dynamic Typing with `any`

```hcl
variable "dynamic_input" {
  type = any
}
```

---

#### 📤 `output` Block

Outputs allow you to expose specific values after `terraform apply`.

```hcl
output "instance_id" {
  value       = aws_instance.web.id
  description = "The ID of the created EC2 instance"
}
```

You can view outputs using:

```bash
terraform output
```

---

#### 🔼 Input Variable Precedence

When defining a variable, Terraform will choose the value based on the following order (highest to lowest):

1. `-var` or `-var-file` CLI options
2. Environment variables (`TF_VAR_name`)
3. `terraform.tfvars` or any `*.auto.tfvars`
4. Default value in `variable` block

---

## 🧪 Hands-On Lab: Variables & Outputs

Let’s create a module that uses various types of variables and prints meaningful outputs.

### 📁 File Structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
```

---

### 🔧 `variables.tf`

```hcl
variable "instance_name" {
  type        = string
  default     = "my-instance"
  description = "Name of the EC2 instance"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Owner       = "ashu"
  }
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443]
}
```

---

### 🖥️ `main.tf`

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  tags = merge(
    {
      Name = var.instance_name
    },
    var.tags
  )
}
```

---

### 📤 `outputs.tf`

```hcl
output "instance_name" {
  value = aws_instance.web.tags["Name"]
}

output "instance_id" {
  value = aws_instance.web.id
}

output "open_ports" {
  value = var.ports
}
```

---

### 📋 `terraform.tfvars`

```hcl
instance_name = "terraform-demo"
tags = {
  Environment = "test"
  Owner       = "student"
}
ports = [22, 8080]
```

---

### 🧪 Run the Workflow

```bash
terraform init
terraform plan
terraform apply
terraform output
```

---

## 🧵 Summary

In this lesson, you’ve learned:

- How to define and use variables of different types
- How to pass input values via `.tfvars` or CLI
- How to use `output` blocks to reveal resource properties
- Terraform v1.12's expanded support for complex and dynamic data types

---
