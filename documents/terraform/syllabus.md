# 📘 Terraform v1.12 Complete Learning Guide

## ✅ Prerequisites

- Basic understanding of cloud platforms (like AWS, Azure, GCP)
- Installed Terraform CLI (v1.12)
- Installed a code editor (like VS Code)
- An active cloud provider account (e.g., AWS Free Tier)

---

## 🧱 1. Terraform Basics

### Topics Covered:

- What is Terraform?
- Infrastructure as Code (IaC) concepts
- Declarative vs Imperative approaches
- Terraform Workflow (Init → Plan → Apply → Destroy)

### Hands-On:

- Install Terraform 1.12
- Create a basic `main.tf` with a local resource (like `null_resource`)

---

## 📁 2. Terraform File Structure

### Topics Covered:

- `.tf` files
- `.tfstate` and `.tfstate.backup`
- `.terraform/` directory
- `terraform.tfvars` and variable definitions

---

## 🔤 3. Variables and Outputs

### Topics Covered:

- `variable` block with `type`, `default`, and `description`
- New variable type support in v1.12 (e.g., `object`, `tuple`)
- `output` block usage
- Input variable precedence (env var, CLI var, tfvars, default)

### Hands-On:

- Create a module with variables of different types
- Print outputs after `apply`

---

## 📦 4. Providers and Resources

### Topics Covered:

- Provider configuration
- AWS/GCP/Azure provider example
- `resource` block syntax
- Resource lifecycle meta-arguments (`create_before_destroy`, `prevent_destroy`)

### Hands-On:

- Create an EC2 instance or S3 bucket using AWS provider

---

## 📄 5. Terraform CLI Commands

### Topics Covered:

- `init`, `plan`, `apply`, `destroy`, `validate`, `refresh`
- `fmt`, `taint`, `untaint`, `import`
- `state`, `output`, `console`

---

## 🔁 6. Control Structures

### Topics Covered:

- `count` vs `for_each`
- Conditional resources using `count = var.enabled ? 1 : 0`
- `for` loops inside locals, outputs, dynamic blocks

---

## 🧮 7. Functions in Terraform

### Topics Covered:

- Built-in functions: `length()`, `join()`, `lookup()`, `merge()`, `file()`
- Type conversion functions: `tostring()`, `tolist()`, etc.
- Date and math functions

### Hands-On:

- Use functions inside locals and outputs

---

## 🧷 8. Locals

### Topics Covered:

- Syntax and use cases for `locals`
- Combine locals with expressions and functions for clean code

---

## 📚 9. Modules

### Topics Covered:

- Module basics
- Calling modules
- Passing variables to/from modules
- Using `source` from local path or GitHub
- `module` outputs and nesting
- `module` meta-arguments

### Hands-On:

- Create and reuse a VPC module
- Create a module for EC2 + Security Group + Key Pair

---

## 🔐 10. State Management

### Topics Covered:

- Local vs Remote state
- State file structure
- `terraform state` commands
- Locking and consistency
- Sensitive values in state

### Hands-On:

- Set up remote backend using S3 (with DynamoDB for locking)

---

## 🚦 11. Data Sources

### Topics Covered:

- `data` block syntax
- Common data sources: `aws_ami`, `aws_vpc`, `aws_subnet`, etc.
- Chaining data into resources

---

## 🧠 12. Expressions and Data Types (Major v1.12 Update)

### Topics Covered:

- Dynamic types: `object`, `tuple`, `any`
- Complex expressions using `for`, `if`, `length()`, `merge()`, etc.
- Conditional expressions: `condition ? true_val : false_val`
- Splat expressions (`*` operator)
- Dynamic blocks

### Hands-On:

- Write a module that takes a list of maps and creates multiple S3 buckets or EC2 instances
- Use `for_each`, `count`, and `dynamic` blocks

---

## 🔍 13. Debugging & Logging

### Topics Covered:

- Debugging with `TF_LOG` and `TF_LOG_PATH`
- Using `terraform console` for expression testing
- Syntax error messages and troubleshooting

---

## 🔄 14. Terraform Lifecycle

### Topics Covered:

- Resource lifecycle management
- Meta-arguments: `depends_on`, `lifecycle`
- Handling drift

---

## 🛠️ 15. Advanced Concepts

### Topics Covered:

- Dynamic Blocks (new in 1.12)
- Complex nested object variables
- Optional Object Attributes (via `optional()` in future versions, but can mock via `null`)
- Module Composition and Abstraction
- Workspaces

---

## 📦 16. External Data & Provisioners

### Topics Covered:

- `external` data source
- `local-exec` and `remote-exec` provisioners
- Avoiding provisioners unless necessary

---

## 📚 17. Real-World Project Examples

- VPC creation with subnets, route tables, and IGWs
- EC2 instances with Security Groups and IAM roles
- RDS setup with parameter groups
- EKS or ECS setup (for advanced learners)

---

## 🧪 18. Testing and Validation

- `terraform validate`
- Use `kitchen-terraform` or `terratest` (Go-based) for unit testing
- Best practices for writing testable modules

---

## 🔐 19. Security Best Practices

- Avoid hardcoding credentials
- Use IAM roles or environment variables
- Use `sensitive = true` for outputs
- Remote state encryption and access control

---

## 📈 20. Best Practices & CI/CD

- GitOps and version control
- Terraform in CI/CD pipelines
- Environment isolation with workspaces
- Module versioning and registry usage
