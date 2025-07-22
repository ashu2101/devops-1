# ✅ Prerequisites for Learning Terraform v1.12

Terraform is a powerful Infrastructure as Code (IaC) tool that allows you to define and provision infrastructure using a high-level configuration language. Before diving into the world of Terraform, it’s essential to ensure that your environment and foundational knowledge are ready. This document outlines the key prerequisites needed to start working effectively with **Terraform v1.12**.

---

## 1. 🌐 Basic Understanding of Cloud Platforms

Before working with Terraform, you should have a basic understanding of at least one major cloud platform, such as:

- **AWS (Amazon Web Services)**
- **Microsoft Azure**
- **Google Cloud Platform (GCP)**

### Concepts to Know:

- Compute resources (e.g., EC2, VM instances)
- Networking components (VPC, Subnets, Firewalls)
- Storage services (S3, Blob Storage, Buckets)
- Identity and Access Management (IAM)

Having this foundational cloud knowledge will help you understand the resources you're provisioning through Terraform.

---

## 2. 🔧 Install Terraform CLI (v1.12)

To get started, you must have **Terraform CLI version 1.12** installed on your local machine.

### Installation Steps:

#### For Windows:

1. Download Terraform v1.12 from the official release archive: [https://releases.hashicorp.com/terraform/1.12.0/](https://releases.hashicorp.com/terraform/1.12.0/)
2. Unzip the file and add the directory to your system `PATH`.
3. Verify installation with:

   ```sh
   terraform -version
   ```

#### For macOS:

```sh
brew install terraform@1.12
brew link --force terraform@1.12
```

#### For Linux:

```sh
wget https://releases.hashicorp.com/terraform/1.12.0/terraform_1.12.0_linux_amd64.zip
unzip terraform_1.12.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform -version
```

> 💡 Tip: Always verify that your version is `v1.12.x` using `terraform -version`.

---

## 3. 🧑‍💻 Install a Code Editor (Recommended: VS Code)

A good code editor makes writing Terraform configuration easier and more productive.

### Recommended Editor: **Visual Studio Code (VS Code)**

Download: [https://code.visualstudio.com/](https://code.visualstudio.com/)

### Extensions:

- **HashiCorp Terraform**: Adds syntax highlighting, IntelliSense, and validation
- **Prettier**: For consistent formatting
- **Bracket Pair Colorizer** _(optional)_: Helps with nested blocks

---

## 4. ☁️ Active Cloud Provider Account

You will need an active account on at least one cloud provider. We recommend starting with **AWS Free Tier**, which provides enough resources to learn and experiment with Terraform.

### AWS Free Tier Setup:

1. Sign up at: [https://aws.amazon.com/free](https://aws.amazon.com/free)
2. Create an **IAM user** with `AdministratorAccess` for Terraform use
3. Generate **Access Key ID** and **Secret Access Key**
4. Configure credentials locally:

   ```sh
   aws configure
   ```

> 🔐 Be cautious with your credentials. Never hardcode them in `.tf` files. Use environment variables or credentials file.

---

## ✅ Summary Checklist

| Requirement                     | Status |
| ------------------------------- | ------ |
| Understand basic cloud concepts | ✅     |
| Terraform CLI v1.12 installed   | ✅     |
| VS Code with Terraform plugins  | ✅     |
| Cloud provider account ready    | ✅     |

Once you’ve met all the above prerequisites, you’re ready to begin your Terraform journey!

---
