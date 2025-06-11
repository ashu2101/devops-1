
## 📄 **Introduction to AWS CLI**

### What is AWS CLI?

The **AWS Command Line Interface (CLI)** is a unified tool that allows you to manage AWS services from the command line. With AWS CLI, you can automate tasks, manage resources, and interact with AWS services without using the AWS Management Console.

---

### 🚀 Getting Started

#### 1️⃣ Install AWS CLI

* On **macOS**:

  ```bash
  brew install awscli
  ```

* On **Linux**:

  ```bash
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  ```

* On **Windows**:
  Download the installer from [AWS CLI Downloads](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

Verify installation:

```bash
aws --version
```

---

#### 2️⃣ Configure AWS CLI

Run this command and follow the prompts:

```bash
aws configure
```

You'll need:

* **AWS Access Key ID**
* **AWS Secret Access Key**
* **Default region** (e.g., `us-east-1`)
* **Default output format** (e.g., `json`, `table`, `text`)

These credentials are typically created from the AWS Console → IAM → Users → *your user* → Security credentials.

---

### 📋 Basic AWS CLI Commands

Here are some commonly used AWS CLI commands:

#### 🔸 **S3 (Simple Storage Service)**

* **List buckets:**

  ```bash
  aws s3 ls
  ```

* **Create a new bucket:**

  ```bash
  aws s3 mb s3://my-new-bucket
  ```

* **Upload a file:**

  ```bash
  aws s3 cp myfile.txt s3://my-new-bucket/
  ```

* **Download a file:**

  ```bash
  aws s3 cp s3://my-new-bucket/myfile.txt .
  ```

* **Delete a file:**

  ```bash
  aws s3 rm s3://my-new-bucket/myfile.txt
  ```

---

#### 🔸 **EC2 (Elastic Compute Cloud)**

* **List EC2 instances:**

  ```bash
  aws ec2 describe-instances
  ```

* **Start an instance:**

  ```bash
  aws ec2 start-instances --instance-ids i-0123456789abcdef0
  ```

* **Stop an instance:**

  ```bash
  aws ec2 stop-instances --instance-ids i-0123456789abcdef0
  ```

---

#### 🔸 **IAM (Identity and Access Management)**

* **List users:**

  ```bash
  aws iam list-users
  ```

* **List roles:**

  ```bash
  aws iam list-roles
  ```

---

#### 🔸 **CloudFormation (Infrastructure as Code)**

* **List stacks:**

  ```bash
  aws cloudformation list-stacks
  ```

* **Create a stack:**

  ```bash
  aws cloudformation create-stack --stack-name my-stack --template-body file://template.yaml
  ```

---

#### 🔸 **General AWS Info**

* **Get AWS CLI help:**

  ```bash
  aws help
  ```

* **Get service-specific help:**

  ```bash
  aws s3 help
  ```

---

### 📌 Useful Tips

✅ Use **profiles** for multiple AWS accounts:

```bash
aws configure --profile myprofile
```

Then run:

```bash
aws s3 ls --profile myprofile
```

✅ To check the current configuration:

```bash
cat ~/.aws/credentials
cat ~/.aws/config
```

✅ Output in different formats:

```bash
aws ec2 describe-instances --output table
aws ec2 describe-instances --output json
```

---

### 🌐 Official Documentation

* [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
* [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)

---


