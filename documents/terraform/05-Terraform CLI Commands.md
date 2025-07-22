# 📄 5. Terraform CLI Commands

Terraform’s CLI is your gateway to managing infrastructure. These commands allow you to initialize, inspect, plan, apply, and tear down infrastructure safely and systematically.

---

## 🧠 Topics Covered

### 🔧 Core Workflow Commands

#### `terraform init`

Initializes the working directory, downloads providers, and prepares the backend.

```bash
terraform init
```

#### `terraform plan`

Shows the execution plan without making changes.

```bash
terraform plan
```

#### `terraform apply`

Applies the changes required to reach the desired state.

```bash
terraform apply
```

#### `terraform destroy`

Destroys the resources managed by Terraform.

```bash
terraform destroy
```

#### `terraform validate`

Checks whether the configuration is syntactically valid.

```bash
terraform validate
```

#### `terraform refresh`

Synchronizes the Terraform state file with the real-world infrastructure.

```bash
terraform refresh
```

> ⚠️ Deprecated in later versions but still present in 1.12.

---

### 🧹 Formatting and Debugging

#### `terraform fmt`

Formats your Terraform code according to canonical style.

```bash
terraform fmt
```

#### `terraform taint`

Marks a resource for recreation during the next `apply`.

```bash
terraform taint aws_instance.web
```

#### `terraform untaint`

Unmarks a resource previously tainted.

```bash
terraform untaint aws_instance.web
```

---

### 🔍 Inspect & Manipulate State

#### `terraform state list`

Lists all resources in the current state.

```bash
terraform state list
```

#### `terraform state show`

Displays the attributes of a specific resource.

```bash
terraform state show aws_instance.web
```

#### `terraform state rm`

Removes a resource from the state file (without destroying it).

```bash
terraform state rm aws_instance.web
```

---

### 🔄 Resource Import

#### `terraform import`

Brings existing infrastructure under Terraform management.

```bash
terraform import aws_instance.web i-0abcd1234ef567890
```

> 🔐 You must declare the resource in `.tf` first.

---

### 📤 Output and Interactive Mode

#### `terraform output`

Displays values from `output` blocks.

```bash
terraform output
```

#### `terraform console`

Launches an interactive console to evaluate expressions.

```bash
terraform console
> length(["a", "b", "c"])
```

---

## ✅ Summary

| Command           | Purpose                                   |
| ----------------- | ----------------------------------------- |
| `init`            | Initialize working directory              |
| `plan`            | Preview changes before applying           |
| `apply`           | Execute the changes                       |
| `destroy`         | Tear down resources                       |
| `validate`        | Check for syntax errors                   |
| `fmt`             | Format Terraform code                     |
| `taint`/`untaint` | Mark/unmark resources for recreation      |
| `import`          | Bring existing resources into Terraform   |
| `state` commands  | View or manipulate state                  |
| `output`          | Display values defined in `output` blocks |
| `console`         | Run interactive HCL evaluations           |

---
