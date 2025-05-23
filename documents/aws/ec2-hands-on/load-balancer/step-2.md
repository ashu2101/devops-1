# 🌐 Internet-Facing ALB with Path-Based Routing to HTML Pages on EC2

## ✅ Overview

This setup includes:

- An **Internet-facing Application Load Balancer (ALB)**

- **Two EC2 target groups**:

  - One for serving `index.html` at `/`

  - One for serving `admin.html` at `/admin`

- **Path-based routing rules**

- **Secure EC2 instance access** (only port 80 open to ALB or defined CIDR)

---

## 🏗️ Prerequisites

- Two EC2 instances running in separate AZs/subnets:

  - Instance 1: serves both `index.html` and `admin.html`

  - Instance 2: serves only `index.html`

- `httpd` installed and serving files from `/var/www/html`

- No public IP on EC2s (use Systems Manager to log in)

---

## 🛠️ Step 1: Create Target Groups

Go to **EC2 > Target Groups**, and create:

### 🔹 `tg-index`

- **Target type**: Instances

- **Protocol**: HTTP

- **Port**: 80

- Register both EC2 instances

### 🔸 `tg-admin`

- Same as above

- Register only **Instance 1**

---

## 🌐 Step 2: Create Internet-Facing ALB

Go to **EC2 > Load Balancers** → **Application Load Balancer**:

- **Name**: `html-path-router`

- **Scheme**: Internet-facing

- **Listener**: HTTP (Port 80)

- **AZs**: Select at least 2 AZs

- **Security Group**: Allow inbound HTTP (port 80) from `0.0.0.0/0`

---

## 🔐 Step 3: EC2 Security Group Configuration

### ✅ Goal: Allow Only Port 80 from ALB

1.  **Create a new Security Group for EC2 instances**:

    - **Inbound rule**:

      - Type: HTTP

      - Port: 80

      - Source:

        - Option 1: **ALB Security Group ID**

        - Option 2: **VPC CIDR** (e.g., `10.0.0.0/16`)

2.  **Remove all other inbound rules** (especially SSH or public access)

3.  **Attach this SG** to both EC2 instances.

> ✅ Best practice: Use **ALB Security Group ID** as the source to restrict traffic only to the load balancer.

---

## 🎯 Step 4: Configure Routing Rules

### ➕ Default Rule (Root `/`)

- **Forward to**: `tg-index`

### ➕ Add Path Rule

- **Path**: `/admin`

- **Forward to**: `tg-admin`

---

## 🧪 Example Test URLs

Suppose your ALB DNS is:

arduino

CopyEdit

`http://html-path-router-123456789.ap-south-1.elb.amazonaws.com`

### Access root (`/`):

arduino

CopyEdit

`http://html-path-router-123456789.ap-south-1.elb.amazonaws.com/`

### Access admin (`/admin`):

bash

CopyEdit

`http://html-path-router-123456789.ap-south-1.elb.amazonaws.com/admin`

---

## 📁 HTML File Placement on EC2s

| EC2 Instance | Path     | File                        |
| ------------ | -------- | --------------------------- |
| Instance 1   | `/`      | `1-index.html → index.html` |
|              | `/admin` | `admin.html → admin.html`   |
| Instance 2   | `/`      | `2-index.html → index.html` |

### Move files after installing `httpd`:

bash

CopyEdit

`sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

sudo mv /tmp/1-index.html /var/www/html/index.html
sudo mv /tmp/admin.html /var/www/html/admin.html`

Instance 2:

bash

CopyEdit

`sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

sudo mv /tmp/2-index.html /var/www/html/index.html`

---

## ✅ Summary

| Component             | Configured            |
| --------------------- | --------------------- |
| ALB (Internet-facing) | ✅ Yes                |
| Two Target Groups     | ✅ tg-index, tg-admin |
| Path-Based Routing    | ✅ / and /admin       |
| EC2 Web Servers       | ✅ Yes                |
| SG on EC2 (Port 80)   | ✅ Restricted to ALB  |
