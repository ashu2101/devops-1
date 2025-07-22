# 📦 4. Providers and Resources

In this module, we explore how Terraform interacts with cloud platforms through **providers**, and how you define **resources** that Terraform manages. Providers enable Terraform to communicate with your chosen cloud or service, while resources describe the infrastructure components to be created.

---

## 🧠 Topics Covered

### ✅ Provider Configuration

A **provider** is a plugin that allows Terraform to interact with external APIs such as AWS, Azure, or GCP.

**Example: AWS Provider Configuration**

```hcl
provider "aws" {
  region  = var.aws_region
  profile = "default"  # Optional: set AWS CLI profile
}
```

**Example: Azure Provider**

```hcl
provider "azurerm" {
  features = {}
}
```

**Example: Google Cloud Provider**

```hcl
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
```

> 🔐 Ensure you have valid credentials configured via CLI tools or environment variables (e.g., `aws configure` for AWS).

---

### 🧱 `resource` Block Syntax

A **resource** block tells Terraform what to create. General syntax:

```hcl
resource "<PROVIDER_TYPE>" "<LOCAL_NAME>" {
  # arguments
}
```

**Example: AWS EC2 Instance**

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  tags = {
    Name = "WebServer"
  }
}
```

**Example: AWS S3 Bucket**

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-demo-bucket-2025"
  acl    = "private"
}
```

---

### ⚙️ Resource Lifecycle Meta-Arguments

Terraform provides advanced control over resource behavior using **meta-arguments** within a resource block:

#### 🔄 `create_before_destroy`

Ensures a new resource is created before destroying the old one (useful for stateful resources like load balancers).

```hcl
lifecycle {
  create_before_destroy = true
}
```

#### 🛑 `prevent_destroy`

Prevents a resource from being accidentally destroyed.

```hcl
lifecycle {
  prevent_destroy = true
}
```

#### 🔃 `ignore_changes`

Ignores specific changes to resource attributes (e.g., for manual updates made outside Terraform).

```hcl
lifecycle {
  ignore_changes = [
    tags["LastUpdated"]
  ]
}
```

---

## 🧪 Hands-On Lab: Create AWS Resources

### 🖥️ EC2 Instance + S3 Bucket

#### `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "DemoEC2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "terraform-free-tier-bucket-${random_id.suffix.hex}"
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}
```

#### `outputs.tf`

```hcl
output "instance_id" {
  value = aws_instance.demo_ec2.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.demo_bucket.bucket
}
```

---

## ▶️ Commands to Run

```bash
terraform init
terraform plan
terraform apply
```

You should see outputs showing your EC2 instance ID and the S3 bucket name. When finished:

```bash
terraform destroy
```

> 🚨 Terraform will **refuse to destroy** the S3 bucket due to `prevent_destroy`. You must remove that line to allow deletion.

---

## ✅ Summary

| Concept             | Description                                       |
| ------------------- | ------------------------------------------------- |
| Provider            | Bridge to external platforms (AWS, GCP, Azure)    |
| Resource            | Definition of infrastructure elements             |
| Lifecycle meta-args | Custom behavior for resource creation/destruction |
| Hands-on Outputs    | EC2 instance + uniquely named S3 bucket           |

---
