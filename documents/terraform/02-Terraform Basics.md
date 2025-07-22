# 🧱 1. Terraform Basics

In this section, we’ll lay the foundation for understanding what Terraform is, why it’s widely adopted in the industry, and how to use it effectively to define and provision infrastructure as code.

---

## 📖 What is Terraform?

**Terraform** is an open-source infrastructure as code (IaC) tool developed by [HashiCorp](https://www.hashicorp.com/). It allows you to define, manage, and provision cloud and on-premise infrastructure in a safe, consistent, and repeatable manner.

Terraform uses a custom domain-specific language called **HCL (HashiCorp Configuration Language)** which is human-readable and easy to learn. It supports multiple cloud providers like AWS, Azure, GCP, and many more through plugins known as **providers**.

### Key Features:

- Platform agnostic
- Declarative syntax
- Supports multi-cloud deployments
- Uses dependency graphing for efficient resource management
- Built-in state management

---

## 🏗️ Infrastructure as Code (IaC)

**Infrastructure as Code (IaC)** is the practice of managing and provisioning infrastructure through code rather than manual processes. This approach brings automation, version control, testing, and repeatability to infrastructure.

### Benefits of IaC:

- **Consistency**: Avoids configuration drift and manual errors
- **Speed**: Automates repetitive provisioning tasks
- **Version Control**: Track changes over time using tools like Git
- **Documentation**: The code serves as documentation of your infrastructure
- **Auditability**: Easy to trace changes and access history

IaC is a foundational DevOps practice that enables organizations to manage complex environments efficiently.

---

## 🔁 Declarative vs Imperative Approaches

Terraform follows a **declarative** programming paradigm.

### Declarative:

You declare _what_ the final state of your infrastructure should look like. The tool figures out _how_ to achieve that state.

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

> This configuration tells Terraform to ensure a t2.micro EC2 instance with a specific AMI exists, without specifying the steps to create it.

### Imperative:

You define _how_ to achieve a certain result step-by-step. This is common in shell scripts or manual processes.

```bash
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t2.micro
```

> Here, every step is explicitly defined.

**Terraform’s declarative approach** results in cleaner, more maintainable, and scalable infrastructure code.

---

## 🔄 Terraform Workflow (Init → Plan → Apply → Destroy)

Terraform operates in a structured workflow designed to ensure changes are reviewed and safe before being applied.

### 1. `terraform init`

Initializes the working directory by downloading the required providers and setting up the backend (if defined).

```sh
terraform init
```

### 2. `terraform plan`

Creates an execution plan by comparing the current configuration with the infrastructure's current state. It shows the changes Terraform will make.

```sh
terraform plan
```

### 3. `terraform apply`

Applies the changes required to reach the desired state of the configuration.

```sh
terraform apply
```

### 4. `terraform destroy`

Destroys all infrastructure created by Terraform, reverting your environment to a clean state.

```sh
terraform destroy
```

---

## 👨‍💻 Hands-On Lab: Hello Terraform with `null_resource`

Let’s create a simple configuration using Terraform’s `null_resource`, which performs actions without provisioning any cloud resources. This helps validate your setup.

### Step 1: Create a Working Directory

```bash
mkdir terraform-basics && cd terraform-basics
```

### Step 2: Write a Basic Terraform File

Create a file called `main.tf` and paste the following code:

```hcl
resource "null_resource" "hello" {
  provisioner "local-exec" {
    command = "echo Hello, Terraform!"
  }
}
```

This tells Terraform to run a local shell command when the resource is created.

### Step 3: Run Terraform Commands

Initialize the project:

```bash
terraform init
```

Preview the actions Terraform will take:

```bash
terraform plan
```

Apply the configuration:

```bash
terraform apply
```

Respond with `yes` when prompted. You should see:

```bash
Hello, Terraform!
```

Destroy the resource:

```bash
terraform destroy
```

### ✅ Outcome

You’ve now successfully installed and run Terraform, understood its workflow, and executed a basic configuration using `null_resource`. This confirms that your environment is ready for provisioning real infrastructure.

---
