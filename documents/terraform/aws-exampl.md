# 🚀 Provisioning AWS Free Tier Resources with Terraform v1.12

In this lesson, we transition from running local `null_resource` examples to provisioning **real infrastructure** in the **AWS Free Tier** using Terraform v1.12. You’ll learn how to define cloud infrastructure in code, authenticate securely, and launch an EC2 instance—all from your terminal.

> 🧠 This hands-on guide assumes you’ve already configured your AWS CLI credentials using `aws configure` and have Terraform v1.12 installed.

---

## 🧱 What We Will Provision

We will provision a simple **t2.micro EC2 instance** (eligible for AWS Free Tier) in the `us-east-1` region. This instance will:

- Use an Amazon Linux 2 AMI
- Be launched in the default VPC
- Be accessible via SSH (in real-world use)

---

## 📁 Project Structure

Create a new project folder:

```bash
mkdir terraform-aws-ec2 && cd terraform-aws-ec2
```

Create the following files:

- `main.tf` – Terraform configuration
- `variables.tf` – Input variables
- `outputs.tf` – Output values
- `provider.tf` – AWS provider configuration

---

## 🔐 `provider.tf`: AWS Configuration

```hcl
provider "aws" {
  region = var.aws_region
}
```

---

## 📦 `variables.tf`: Input Variables

```hcl
variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region to deploy resources"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 instance type"
}
```

---

## ⚙️ `main.tf`: EC2 Instance Resource

```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI in us-east-1
  instance_type = var.instance_type

  tags = {
    Name = "Terraform-FreeTier-EC2"
  }
}
```

> 🔍 Note: You can find the correct AMI ID for your region by running:
>
> ```sh
> aws ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2' --query 'Images[*].[ImageId,Name]' --output text
> ```

---

## 📤 `outputs.tf`: Display Instance Information

```hcl
output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
```

---

## ▶️ Terraform Commands

### Step 1: Initialize the project

```bash
terraform init
```

### Step 2: View the execution plan

```bash
terraform plan
```

### Step 3: Apply the configuration

```bash
terraform apply
```

Confirm with `yes` when prompted.

### Step 4: Output will include:

```
Apply complete! Resources: 1 added.

Outputs:
instance_id = i-xxxxxxxxxxxxxxxxx
public_ip   = 3.92.xxx.xxx
```

### Step 5: Destroy the instance when done

```bash
terraform destroy
```

Confirm with `yes` to avoid charges beyond the Free Tier.

---

## 🛡️ Security Tip

This example creates an instance **without a key pair or security group**, meaning it's not accessible via SSH. This is intentional for safety. In future lessons, we will:

- Create and use a key pair
- Attach a security group allowing SSH or HTTP access

---

## ✅ Summary

You have now provisioned your **first real AWS resource** using Terraform!

| Resource       | Value          |
| -------------- | -------------- |
| Type           | EC2 (t2.micro) |
| Provider       | AWS            |
| Region         | us-east-1      |
| Terraform Ver. | 1.12           |

---
