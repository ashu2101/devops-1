# AWS CLI In-Depth Guide: EC2, S3, and VPC

The AWS Command Line Interface (CLI) is a powerful tool to manage and automate AWS services. This guide provides an in-depth understanding of the AWS CLI, focusing on EC2, S3, and VPC services with real-world examples.

---

## 📌 Prerequisites

- Install the AWS CLI: [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Configure credentials:

  ```bash
  aws configure
  ```

  - Provide Access Key ID, Secret Access Key, default region, and output format (e.g., json).

---

## 🖥️ EC2 (Elastic Compute Cloud)

### 1. List EC2 Instances

```bash
aws ec2 describe-instances
```

Add filtering by tag:

```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=MyServer"
```

### 2. Start an EC2 Instance

```bash
aws ec2 start-instances --instance-ids i-0123456789abcdef0
```

### 3. Stop an EC2 Instance

```bash
aws ec2 stop-instances --instance-ids i-0123456789abcdef0
```

### 4. Reboot an EC2 Instance

```bash
aws ec2 reboot-instances --instance-ids i-0123456789abcdef0
```

### 5. Terminate an Instance

```bash
aws ec2 terminate-instances --instance-ids i-0123456789abcdef0
```

### 6. Create a Key Pair

```bash
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
chmod 400 MyKeyPair.pem
```

### 7. SSH into EC2 via SSM

```bash
aws ssm start-session --target i-0123456789abcdef0
```

### 8. Launch a New Instance

```bash
aws ec2 run-instances \
  --image-id ami-0abcdef1234567890 \
  --count 1 \
  --instance-type t2.micro \
  --key-name MyKeyPair \
  --security-groups my-sg \
  --subnet-id subnet-1234abcd
```

---

## 📦 S3 (Simple Storage Service)

### 1. List Buckets

```bash
aws s3 ls
```

### 2. Create a Bucket

```bash
aws s3 mb s3://my-bucket-name
```

### 3. Upload a File

```bash
aws s3 cp myfile.txt s3://my-bucket-name/
```

### 4. Download a File

```bash
aws s3 cp s3://my-bucket-name/myfile.txt ./
```

### 5. Sync a Local Directory to a Bucket

```bash
aws s3 sync ./localdir s3://my-bucket-name/
```

### 6. Delete a File in S3

```bash
aws s3 rm s3://my-bucket-name/myfile.txt
```

### 7. Delete a Bucket

```bash
aws s3 rb s3://my-bucket-name --force
```

---

## 🌐 VPC (Virtual Private Cloud)

### 1. Create a VPC

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```

### 2. List VPCs

```bash
aws ec2 describe-vpcs
```

### 3. Create a Subnet

```bash
aws ec2 create-subnet \
  --vpc-id vpc-abcdef12 \
  --cidr-block 10.0.1.0/24
```

### 4. Create an Internet Gateway

```bash
aws ec2 create-internet-gateway
```

### 5. Attach Internet Gateway to VPC

```bash
aws ec2 attach-internet-gateway \
  --internet-gateway-id igw-abc12345 \
  --vpc-id vpc-abcdef12
```

### 6. Create a Route Table

```bash
aws ec2 create-route-table --vpc-id vpc-abcdef12
```

### 7. Create a Route to Internet Gateway

```bash
aws ec2 create-route \
  --route-table-id rtb-abc12345 \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id igw-abc12345
```

### 8. Associate Route Table with Subnet

```bash
aws ec2 associate-route-table \
  --subnet-id subnet-abc12345 \
  --route-table-id rtb-abc12345
```

---

## 📖 Tips & Best Practices

- Use `--query` for clean output:

  ```bash
  aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name]" --output table
  ```

- Use profiles for multiple accounts:

  ```bash
  aws configure --profile my-dev-profile
  aws ec2 describe-instances --profile my-dev-profile
  ```

- Automate repetitive tasks using shell scripts.
- Secure credentials using IAM roles on EC2 and avoid hardcoding keys.

---

## 📚 Resources

- AWS CLI Official Docs: [https://docs.aws.amazon.com/cli/latest/index.html](https://docs.aws.amazon.com/cli/latest/index.html)
- EC2 CLI Reference: [https://docs.aws.amazon.com/cli/latest/reference/ec2/](https://docs.aws.amazon.com/cli/latest/reference/ec2/)
- S3 CLI Reference: [https://docs.aws.amazon.com/cli/latest/reference/s3/](https://docs.aws.amazon.com/cli/latest/reference/s3/)
- VPC CLI Reference: [https://docs.aws.amazon.com/cli/latest/reference/ec2/index.html#cli-aws-ec2](https://docs.aws.amazon.com/cli/latest/reference/ec2/index.html#cli-aws-ec2)

---
