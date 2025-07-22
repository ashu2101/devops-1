# 📚 9. Modules in Terraform

Terraform **modules** are containers for multiple resources that are used together. Modules help you **organize**, **reuse**, and **standardize** infrastructure across teams, projects, and environments.

---

## 🧠 Topics Covered

### 📦 Module Basics

- Every Terraform configuration is a module.
- You can split infrastructure into **reusable modules**.
- Modules promote **DRY (Don’t Repeat Yourself)** and **clean separation of concerns**.

### 🏗️ Calling a Module

You use the `module` block to reference and use modules:

```hcl
module "ec2_module" {
  source = "./modules/ec2"
  instance_count = 2
  environment    = "dev"
}
```

---

### 🔁 Passing Variables To and From Modules

#### 📥 Inputs

In the module's `variables.tf`:

```hcl
variable "environment" {}
variable "instance_count" {}
```

#### 📤 Outputs

In `outputs.tf`:

```hcl
output "instance_ids" {
  value = aws_instance.web[*].id
}
```

In root module:

```hcl
output "ec2_ids" {
  value = module.ec2_module.instance_ids
}
```

---

### 🌐 Using `source` from Path or GitHub

#### 📁 Local Path

```hcl
source = "./modules/vpc"
```

#### 🌍 GitHub

```hcl
source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v2.77.0"
```

---

### 🔂 Nested Modules

Modules can **call other modules**, forming a tree-like structure. Example:

```hcl
module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source     = "./modules/ec2"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
}
```

---

### ⚙️ `module` Meta-Arguments

- `depends_on`: Define dependencies between modules.
- `count`: Create multiple copies of a module.
- `for_each`: Iterate over a map/set to create multiple modules.

```hcl
module "ec2" {
  source     = "./modules/ec2"
  count      = 2
  instance_name = "web-${count.index}"
}
```

---

## 🧪 Hands-On Projects

---

### 📁 Create & Reuse a VPC Module

#### 📁 Directory Structure

```
modules/
  └── vpc/
      ├── main.tf
      ├── variables.tf
      └── outputs.tf
```

#### `main.tf` (inside `modules/vpc`)

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.name
  }
}
```

#### `variables.tf`

```hcl
variable "vpc_cidr" {}
variable "name" {}
```

#### `outputs.tf`

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}
```

#### Root Module Usage

```hcl
module "vpc" {
  source   = "./modules/vpc"
  name     = "demo-vpc"
  vpc_cidr = "10.0.0.0/16"
}
```

---

### 🖥️ Create a Module for EC2 + Security Group + Key Pair

#### 📁 Directory Structure

```
modules/
  └── ec2/
      ├── main.tf
      ├── variables.tf
      └── outputs.tf
```

#### `main.tf`

```hcl
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = var.name
  }
}
```

#### `variables.tf`

```hcl
variable "ami_id" {}
variable "instance_type" {}
variable "name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "key_name" {}
variable "public_key_path" {}
```

#### `outputs.tf`

```hcl
output "instance_id" {
  value = aws_instance.web.id
}
```

#### Root Usage

```hcl
module "ec2_instance" {
  source           = "./modules/ec2"
  ami_id           = "ami-0c02fb55956c7d316"
  instance_type    = "t2.micro"
  name             = "web-ec2"
  vpc_id           = module.vpc.vpc_id
  subnet_id        = "subnet-abc123"
  key_name         = "deployer-key"
  public_key_path  = "${path.module}/ssh/deployer.pub"
}
```

---

## ✅ Summary

| Concept                | Description                                            |
| ---------------------- | ------------------------------------------------------ |
| Module                 | A collection of Terraform resources                    |
| Input variables        | Passed via `variable` blocks                           |
| Outputs                | Exposed via `output` blocks                            |
| Local vs remote source | Use `source = "./local"` or `source = "github.com/...` |
| Reusability            | Promotes DRY and modular architecture                  |
| Meta-arguments         | Use `count`, `for_each`, and `depends_on` in modules   |

---

# additional :

To support **multiple environments** like `dev`, `test`, and `prod`, you can structure your Terraform project using **workspaces** or **directory-based environments**. The **directory-based approach** is more explicit, easier to manage for teams, and works well with Terraform modules.

---

## ✅ Recommended Project Structure

```
terraform-aws-ec2-instance/
├── modules/
│   └── ec2_module/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── README.md
├── envs/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── test/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
├── .gitignore
└── README.md
```

---

## 🔍 What Each Environment Folder Contains

Each env folder (`dev`, `test`, `prod`) contains its own:

| File               | Description                                                          |
| ------------------ | -------------------------------------------------------------------- |
| `main.tf`          | Calls the reusable module                                            |
| `variables.tf`     | Declares environment-specific input variables                        |
| `terraform.tfvars` | Provides actual values for this environment                          |
| `backend.tf`       | Configures a remote state backend like S3 (optional but recommended) |

---

### 🧩 Sample: `envs/dev/main.tf`

```hcl
module "ec2" {
  source         = "../../modules/ec2_module"
  instance_type  = var.instance_type
  ec2_count      = var.ec2_count
  custom_sg_id   = var.custom_sg_id
}
```

---

### 🧩 Sample: `envs/dev/variables.tf`

```hcl
variable "instance_type" {
  type = string
}

variable "ec2_count" {
  type = number
}

variable "custom_sg_id" {
  type = string
}
```

---

### 🧩 Sample: `envs/dev/terraform.tfvars`

```hcl
instance_type = "t2.micro"
ec2_count     = 1
custom_sg_id  = "sg-0123456789abcdef0"
```

---

### 🗃️ Optional: `envs/dev/backend.tf` (for remote state)

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "dev/ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

Repeat this setup for `test` and `prod` with different values in their `terraform.tfvars`.

---

## 🚀 How to Use

```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```

You can do the same for:

```bash
cd ../test   # or ../prod
```

---

## ✅ Benefits of This Structure

- Clean separation between environments
- Different state files & backends
- Easy to integrate with CI/CD
- Reusable module across all environments

---
