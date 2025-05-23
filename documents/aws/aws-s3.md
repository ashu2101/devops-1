# 🗂️ AWS S3 (Simple Storage Service) - Complete Guide

## 📌 Overview

Amazon S3 (Simple Storage Service) is a highly scalable, durable, and secure object storage service offered by AWS. It allows you to store and retrieve any amount of data from anywhere on the web.

Use cases include:

- Website hosting
- Backup and restore
- Data lake for analytics
- Software delivery
- Archival storage

---

## 🧱 Core Concepts

### 1. **Buckets**

- Containers for storing objects (files)
- Each bucket has a **globally unique name**
- Can be configured for versioning, lifecycle rules, policies, etc.

### 2. **Objects**

- The actual data stored in S3
- Includes file data and metadata
- Maximum object size: 5 TB
- Each object is identified by a key (unique identifier within the bucket)

### 3. **Keys**

- Unique identifiers for objects in a bucket
- Acts like a file path (e.g., `folder1/folder2/file.txt`)

### 4. **Regions**

- Buckets are created in a specific AWS region
- Data is stored redundantly across multiple AZs within that region

---

## 🔐 Security and Access Control

### 1. **IAM Policies**

- Control access using AWS Identity and Access Management (IAM)
- Permissions can be applied to users, groups, and roles

### 2. **Bucket Policies**

- JSON-based access policies attached directly to a bucket
- Useful for granting cross-account access

### 3. **ACLs (Access Control Lists)**

- Legacy way to control access at bucket or object level
- Less flexible than IAM or bucket policies

### 4. **S3 Block Public Access**

- Prevents accidental public exposure
- Recommended for most buckets

### 5. **Encryption**

- **Server-Side Encryption (SSE)**:

  - SSE-S3 (S3 managed keys)
  - SSE-KMS (AWS Key Management Service)
  - SSE-C (customer-provided keys)

- **Client-Side Encryption** also supported

---

## 📦 Storage Classes

S3 offers multiple storage classes designed for different use cases:

| Storage Class           | Use Case                                | Durability    | Availability | Min Storage Duration |
| ----------------------- | --------------------------------------- | ------------- | ------------ | -------------------- |
| S3 Standard             | Frequent access                         | 99.999999999% | 99.99%       | None                 |
| S3 Intelligent-Tiering  | Unknown/Changing access patterns        | 99.999999999% | 99.9%–99.99% | 30–90 days           |
| S3 Standard-IA          | Infrequent access                       | 99.999999999% | 99.9%        | 30 days              |
| S3 One Zone-IA          | Infrequent access, single AZ            | 99.999999999% | 99.5%        | 30 days              |
| S3 Glacier              | Archival, retrieval in minutes/hours    | 99.999999999% | Varies       | 90 days              |
| S3 Glacier Deep Archive | Long-term archiving, retrieval in hours | 99.999999999% | Varies       | 180 days             |

---

## 🔄 Versioning and Lifecycle Management

### 1. **Versioning**

- Keeps multiple versions of an object
- Protects against accidental deletions/overwrites
- Must be enabled explicitly

### 2. **Lifecycle Rules**

- Automate transitions between storage classes
- Automatically delete old versions or incomplete uploads

Example:

```json
{
  "Rules": [
    {
      "ID": "ArchiveOldObjects",
      "Prefix": "",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "GLACIER"
        }
      ],
      "Expiration": {
        "Days": 365
      }
    }
  ]
}
```

---

## 🌐 Static Website Hosting

S3 supports hosting static websites.

- Enable static website hosting on the bucket
- Upload HTML, CSS, JS files
- Configure `index.html` and `error.html`
- Use Route 53 or CloudFront for custom domains and HTTPS

---

## 🔄 Replication

### 1. **Cross-Region Replication (CRR)**

- Automatically replicates objects to another bucket in a different region
- Use cases: disaster recovery, latency reduction

### 2. **Same-Region Replication (SRR)**

- For compliance, data segregation, and backup

**Requirements:**

- Versioning must be enabled
- IAM permissions needed

---

## 🧪 S3 Event Notifications

- Trigger actions when objects are created, deleted, etc.
- Targets:

  - AWS Lambda
  - SNS topics
  - SQS queues

Example use cases:

- Image processing pipelines
- Real-time analytics
- Automation

---

## 🔎 Logging and Monitoring

### 1. **S3 Access Logs**

- Track requests to your S3 buckets

### 2. **AWS CloudTrail**

- Record API calls made to S3

### 3. **Amazon CloudWatch Metrics**

- Storage metrics (total bytes, object count)
- Request metrics (GET, PUT, DELETE, 4xx/5xx errors)

---

## 🧰 Tools and Interfaces

- **AWS Management Console**
- **AWS CLI** (e.g., `aws s3 cp`, `aws s3 ls`)
- **AWS SDKs** for programmatic access
- **S3 REST API**

Example CLI:

```bash
aws s3 cp myfile.txt s3://mybucket/path/
aws s3 ls s3://mybucket --recursive
```

---

## 💡 Best Practices

- Enable versioning and MFA delete for critical buckets
- Use least-privilege IAM permissions
- Enable encryption by default
- Use lifecycle rules to optimize costs
- Block public access unless explicitly needed
- Use S3 Object Lock for regulatory compliance (WORM)

---

## 📚 Summary

Amazon S3 is a foundational service for storing and managing unstructured data at scale. With features like flexible storage classes, powerful access controls, automated lifecycle management, and easy integration with other AWS services, S3 is suitable for use cases ranging from simple backups to enterprise-grade data lakes and application hosting.

Would you like to add **Terraform or CloudFormation** examples for provisioning S3 buckets?
