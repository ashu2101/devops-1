# 🔐 10. State Management in Terraform

Terraform uses a **state file** to keep track of your infrastructure and ensure that what's defined in your `.tf` files matches what's deployed in the real world. Proper state management is **crucial** for reliability, collaboration, and automation.

---

## 🧠 Topics Covered

### 📍 Local vs Remote State

#### Local State (default)

- Stored in `terraform.tfstate`
- Easy to use for testing or local development
- **Not safe** for team use

#### Remote State

- Stores `tfstate` in a remote backend (e.g., S3)
- Supports **locking**, **versioning**, and **shared access**
- Enables **safe collaboration** in teams

---

### 📁 State File Structure

The state file (`terraform.tfstate`) is a **JSON file** that contains:

- Resource types and names
- Input/output values
- Metadata (provider info, dependencies)
- Resource attributes (like IDs, ARNs, tags)

Example snippet:

```json
{
  "resources": [
    {
      "type": "aws_instance",
      "name": "web",
      "instances": [
        {
          "attributes": {
            "ami": "ami-0c02fb55956c7d316",
            "instance_type": "t2.micro",
            "tags": {
              "Name": "web-server"
            }
          }
        }
      ]
    }
  ]
}
```

> ⚠️ Never manually edit this file unless absolutely necessary!

---

### 🛠️ `terraform state` Commands

| Command                           | Purpose                                    |
| --------------------------------- | ------------------------------------------ |
| `terraform state list`            | Show all tracked resources                 |
| `terraform state show <resource>` | Show detailed state of a specific resource |
| `terraform state rm <resource>`   | Remove a resource from state               |
| `terraform state mv <from> <to>`  | Rename or move resource in state           |

#### Example:

```bash
terraform state list
terraform state show aws_instance.web
terraform state rm aws_s3_bucket.old_bucket
terraform state mv aws_instance.old aws_instance.new
```

---

### 🔐 Locking and Consistency

When using remote state (e.g., S3 + DynamoDB):

- **S3** stores the `.tfstate` file
- **DynamoDB** is used to **lock the state** during `apply` or `plan`
- Prevents race conditions when multiple people run Terraform simultaneously

---

## 🧪 Hands-On: Configure Remote Backend with S3 + DynamoDB

### 🎯 Goal:

Move local state to S3 and enable locking with DynamoDB

---

### ✅ Step 1: Create S3 Bucket & DynamoDB Table

```hcl
resource "aws_s3_bucket" "tf_state" {
  bucket = "my-terraform-state-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "TerraformState"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformLocks"
  }
}
```

> ✅ Run `terraform apply` to create these resources.

---

### ✅ Step 2: Configure Remote Backend

Create a new `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

> ❗ You must run `terraform init` again to configure the backend:

```bash
terraform init
```

---

### ✅ Step 3: Verify State Management

```bash
terraform plan
terraform apply
```

Check in your S3 bucket to see the `terraform.tfstate` file. DynamoDB will automatically handle locks during operations.

---

### 🔐 Sensitive Data in State

- State files **contain sensitive values** (e.g., passwords, secrets, access keys)
- Even if you use `sensitive = true` in Terraform, it's still **visible** in state
- Recommendations:

  - **Never commit `.tfstate` to Git**
  - Use encryption (S3 encryption, KMS)
  - Set access controls on S3 bucket

---

## ✅ Summary

| Topic                     | Notes                                         |
| ------------------------- | --------------------------------------------- |
| Local state               | Default, unsafe for collaboration             |
| Remote state              | Enables shared usage, versioning, and locking |
| `terraform state`         | Inspect, modify, or repair state manually     |
| State locking             | Prevents corruption during concurrent usage   |
| S3 + DynamoDB setup       | Best practice for remote state in AWS         |
| Sensitive values in state | Avoid exposing secrets—use encryption and IAM |

---
