# 🛠 EC2 Load Balancing and Path-Based Routing Setup (Manual Configuration)

## ✅ Part 1: Create Two EC2 Instances in Separate AZs

### Region: `ap-south-1` (Mumbai) or `us-east-1` (N. Virginia)

### 🔹 Steps:

1.  **Go to EC2 Dashboard** → Launch Instance

2.  **Select Amazon Machine Image (AMI)**:

    - Choose **Amazon Linux 2 (Free Tier eligible)**

3.  **Instance Type**:

    - `t2.micro` (free tier)

4.  **Network Settings**:

    - **VPC**: Default or your custom VPC

    - **Subnet**:

      - Instance 1: Choose `ap-south-1a` (or `us-east-1a`)

      - Instance 2: Choose `ap-south-1b` (or `us-east-1b`)

    - **Auto-assign Public IP**: ❌ **Disable**

5.  **IAM Role**:

    - Create a role with the following policies:

      - `AmazonSSMManagedInstanceCore`

      - `AmazonS3ReadOnlyAccess`

    - Attach the role to both instances.

6.  **Security Group**:

    - Create or use an SG that allows inbound:

      - Port **80 (HTTP)** from your IP or VPC CIDR

      - Port **443 (optional)** if using HTTPS

      - **No SSH** required (use SSM)

7.  **Storage**:

    - Use default 8 GB or customize

### 🔐 Optional: Create a Key Pair (only if you plan to SSH later)

---

## 🟢 Part 2: Login and Configure EC2 via AWS Console (SSM)

### 📥 Steps to Login:

1.  Go to **AWS Systems Manager > Session Manager**

2.  Choose **Start session**

3.  Select your EC2 instance and click **Start**

---

## 🧰 Part 3: Install Web Server and Serve HTML

### On **Instance 1** (for `/` and `/admin` routes):

bash

CopyEdit

`sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

# Move your HTML files (assume they're in /tmp or transferred via S3/SSM)

sudo mv /tmp/1-index.html /var/www/html/index.html
sudo mv /tmp/admin.html /var/www/html/admin.html`

### On **Instance 2** (for `/` only):

bash

CopyEdit

`sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd

# Move your HTML file

sudo mv /tmp/2-index.html /var/www/html/index.html`

---

## ✅ HTML File Placement Summary

| EC2 Instance       | Path     | File                      |
| ------------------ | -------- | ------------------------- |
| Instance 1 (AZ-1a) | `/`      | 1-index.html → index.html |
|                    | `/admin` | admin.html                |
| Instance 2 (AZ-1b) | `/`      | 2-index.html → index.html |

---

## 📌 Notes

- Ensure both EC2 instances are in **private subnets**, and accessible via **SSM only**.

- You can upload HTML files using:

  - S3 → then use `aws s3 cp`

  - AWS Systems Manager → `Run Command` → copy content

- Once the web servers are running, attach these instances to **target groups** and configure **Application Load Balancer** with:

  - Default rule for `/` → user target group

  - Custom rule for `/admin` → admin target group
