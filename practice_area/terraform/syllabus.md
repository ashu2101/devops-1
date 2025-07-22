# 🌐 1. **Static Website Hosting using S3 + CloudFront + Route53**

### 💼 Industry Use Case:

Startups or small businesses hosting a marketing or documentation website.

### 🔧 Resources:

- S3 Bucket (static website hosting)
- CloudFront distribution (CDN)
- Route53 DNS (optional if you own a domain)
- IAM policy for public read access

### ✅ Free Tier Applicable:

- 5 GB storage in S3
- 1M CloudFront requests/month
- 50 hosted zones/month (Route53 pricing beyond domain cost)

### 📁 Terraform Outline:

```hcl
resource "aws_s3_bucket" "static_site" {
  bucket = "my-static-site"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.s3_public_policy.json
}

# Optional: Add CloudFront and Route53 setup
```

---

# 🧠 2. **Machine Learning Model API on EC2 with EBS**

### 💼 Industry Use Case:

Deploying a small Flask or FastAPI ML model inference server (e.g., sentiment analysis) on a t2.micro instance.

### 🔧 Resources:

- EC2 t2.micro (Free Tier)
- EBS volume (default root volume is free up to 30GB)
- Security group to expose port 5000 or 80
- Optional: Key pair and bootstrap script

### ✅ Free Tier Applicable:

- 750 hours/month for EC2 t2.micro
- 30GB EBS General Purpose SSD

### 📁 Terraform Outline:

```hcl
resource "aws_instance" "ml_api" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  user_data = file("scripts/deploy_model.sh")

  vpc_security_group_ids = [aws_security_group.ml_sg.id]

  tags = {
    Name = "ML-Inference-Server"
  }
}
```

---

# 📈 3. **Real-Time Log Collector using CloudWatch + EC2**

### 💼 Industry Use Case:

Centralized log collection from web apps, using EC2 + CloudWatch Agent.

### 🔧 Resources:

- EC2 instance with CloudWatch Agent installed
- IAM Role with CloudWatch permissions
- Security group for SSH
- CloudWatch Logs group

### ✅ Free Tier Applicable:

- EC2 t2.micro (750 hrs/month)
- 5 GB of log ingestion/month
- 5 GB log archive/month

### 📁 Terraform Outline:

```hcl
resource "aws_cloudwatch_log_group" "logs" {
  name              = "/app/logs"
  retention_in_days = 7
}

resource "aws_iam_role" "cw_agent_role" {
  name = "cloudwatch-agent-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_instance" "log_collector" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.cw_agent_profile.name
  user_data = file("scripts/install-cloudwatch-agent.sh")
}
```

---

# 🧾 4. **Document Upload API using API Gateway + Lambda + S3**

### 💼 Industry Use Case:

A lightweight API for uploading files/documents to S3—ideal for fintech or HR apps.

### 🔧 Resources:

- Lambda function (Python or Node.js)
- S3 bucket for storing documents
- API Gateway (REST API)
- IAM roles for Lambda-S3 access

### ✅ Free Tier Applicable:

- 1M Lambda invocations/month
- 1M API Gateway calls/month
- 5GB S3 storage

### 📁 Terraform Outline:

```hcl
resource "aws_lambda_function" "upload_doc" {
  function_name = "uploadDocument"
  filename      = "lambda_function_payload.zip"
  handler       = "index.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_api_gateway_rest_api" "api" {
  name = "document-upload-api"
}
```

---

# 🛡️ 5. **Internal Team Bastion Host with SSH + Security Group**

### 💼 Industry Use Case:

Internal infrastructure access via SSH for DevOps or data teams.

### 🔧 Resources:

- EC2 t2.micro (Bastion)
- SSH key pair
- Custom security group
- Optional CloudWatch logging

### ✅ Free Tier Applicable:

- EC2 t2.micro
- 750 hours/month
- CloudWatch basic logs

### 📁 Terraform Outline:

```hcl
resource "aws_security_group" "bastion_sg" {
  name = "bastion-ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP/32"]
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name      = "bastion-key"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
}
```

---

## ✅ Summary Table

| Project                 | Key AWS Services Used                       | Industry Use Case             |
| ----------------------- | ------------------------------------------- | ----------------------------- |
| Static Website Hosting  | S3, CloudFront, Route53                     | Marketing, SaaS landing pages |
| ML Model API on EC2     | EC2, Security Groups, EBS                   | AI/ML inference               |
| Real-Time Log Collector | EC2, CloudWatch Logs, IAM Roles             | Infra monitoring/logging      |
| Document Upload API     | Lambda, S3, API Gateway, IAM                | File intake, compliance apps  |
| Internal Bastion Host   | EC2, Security Groups, Key Pairs, CloudWatch | DevOps access, admin tools    |

---
