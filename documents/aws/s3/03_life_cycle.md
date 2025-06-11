# 📊 AWS S3 Lifecycle Policy: Step-by-Step Guide

---

## 1. 🌐 What is an S3 Lifecycle Policy?

An **S3 Lifecycle policy** is a set of rules that define **automated transitions** and **expirations** for objects stored in Amazon S3. It helps in optimizing costs by moving data between storage classes or deleting data when it's no longer needed.

---

## 2. ⚡ Key Use Cases

* Move infrequently accessed data to **S3 Standard-IA** or **S3 Glacier**.
* **Expire/delete** old log files or temporary backup files.
* Transition objects to **cheaper storage classes** over time.
* Retain compliance data for **auditing purposes**.

---

## 3. 📚 Supported Storage Class Transitions

| From        | To                |
| ----------- | ----------------- |
| Standard    | Standard-IA       |
| Standard    | Glacier Instant   |
| Standard    | Glacier Flexible  |
| Standard    | Glacier Deep Arch |
| Standard-IA | Glacier           |

---

## 4. ✅ Steps to Configure Lifecycle Policy (Console)

### Step 1: Go to the S3 Bucket

1. Open AWS Console: [https://s3.console.aws.amazon.com/s3/](https://s3.console.aws.amazon.com/s3/)
2. Select the bucket you want to configure.

### Step 2: Open Management Tab

1. Click on the **"Management"** tab.
2. Under **Lifecycle rules**, click **"Create lifecycle rule"**.

### Step 3: Define Rule

1. Enter a **name** for the rule.
2. Choose whether to apply this rule to:

   * Entire bucket
   * Specific prefix (e.g., `logs/`, `backups/`)
   * Tags (e.g., `"env":"dev"`)

### Step 4: Choose Transitions

* Enable transition to another storage class.
* Define days after object creation when the transition should occur.

### Step 5: Configure Expiration

* Set number of days to **expire/delete** objects.
* Choose to **delete incomplete multipart uploads**.

### Step 6: Review and Create

* Click **"Create rule"** after reviewing all settings.

---

## 5. 📄 JSON Example of Lifecycle Rule

```json
{
  "Rules": [
    {
      "ID": "ArchiveLogs",
      "Prefix": "logs/",
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

## 6. 🤯 Real-World Use Cases

| Use Case                                         | Rule Example         |
| ------------------------------------------------ | -------------------- |
| Delete backups after 90 days                     | Expiration           |
| Archive logs to Glacier after 30 days            | Transition           |
| Delete failed multipart uploads after 7 days     | Multipart Expiration |
| Move user uploads to Deep Archive after 180 days | Transition           |

---

## 7. 🔧 Hands-on Practical


---

## 🛠 Step-by-Step: Configure S3 Lifecycle Policy in AWS Console

### ✅ Prerequisites

* An existing S3 bucket
* Objects inside the bucket (optional, but useful to test)

---

### 📘 Step 1: Navigate to the Bucket

1. Log in to the AWS Management Console.
2. Go to **Services** → **S3**.
3. Click on the bucket where you want to apply the lifecycle policy.

---

### 📘 Step 2: Access the "Management" Tab

1. Inside the bucket settings, click the **"Management"** tab.
2. Scroll to the **"Lifecycle rules"** section.
3. Click **“Create lifecycle rule”**.

---

### 📘 Step 3: Define Rule Basics

1. **Lifecycle rule name**: Enter a descriptive name, like `Expire-Logs-After-30-Days`.
2. **Choose rule scope**:

   * If the rule should apply to **all objects**, leave the default.
   * To limit it, select **Limit the scope to specific prefixes or tags**:

     * Enter a prefix (e.g., `logs/`)
     * OR select object tags (optional)

---

### 📘 Step 4: Choose Actions

You can select one or more of the following **transition and expiration** actions:

#### 📦 Transition Actions (move objects to cheaper storage)

* ✔️ **Transition current versions of objects between storage classes**:

  * Example:

    * 30 days after creation → **S3 Standard-IA**
    * 90 days after creation → **S3 Glacier**
    * 180 days after creation → **S3 Glacier Deep Archive**

* ✔️ **Transition noncurrent versions** (if versioning is enabled):

  * Similar to above, but for noncurrent versions

#### 🗑 Expiration Actions (delete objects)

* ✔️ **Expire current version of object**:

  * Delete after X days (e.g., 365 days after creation)

* ✔️ **Delete expired delete markers** (for versioned buckets)

* ✔️ **Expire noncurrent versions**:

  * Choose how many days to retain noncurrent versions before deleting

---

### 📘 Step 5: Review and Create

1. Review your settings carefully.
2. Click **Create rule**.

The rule will now automatically manage the lifecycle of your S3 objects based on your criteria.

---

## 🧠 Use Cases

| Use Case                   | Description                                                        |
| -------------------------- | ------------------------------------------------------------------ |
| **Log file retention**     | Keep logs in S3 Standard for 30 days, move to Glacier for archival |
| **Data archival**          | Store compliance data cheaply after initial access phase           |
| **Version cleanup**        | Delete old versions of objects to save storage cost                |
| **Auto delete temp files** | Expire temporary files after N days                                |

---

## 🧪 Practice Scenario

Follow this to test your lifecycle configuration:

### Step-by-Step:

1. Create an S3 bucket named `lifecycle-demo-<yourname>`.
2. Upload a few test files with prefix `logs/`.
3. Go to the **Management tab → Lifecycle rules → Create a rule**:

   * Name: `LogsArchival`
   * Prefix: `logs/`
   * Transition after 30 days → S3 Standard-IA
   * Transition after 90 days → Glacier
   * Expire after 365 days
4. Save the rule.
5. Optionally enable **versioning** and try deleting objects to test delete markers.

---


### Using CLI Objective:

* Create a bucket with lifecycle rules for logs.

### Instructions:

1. **Create Bucket**: `aws s3api create-bucket --bucket my-lifecycle-demo --region us-east-1`

2. **Upload Sample Files**:

```bash
aws s3 cp mylogfile.log s3://my-lifecycle-demo/logs/mylogfile.log
```

3. **Create Lifecycle Rule**:

```json
# Save the following as lifecycle.json
{
  "Rules": [
    {
      "ID": "ArchiveLogs",
      "Filter": {
        "Prefix": "logs/"
      },
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 1,
          "StorageClass": "STANDARD_IA"
        }
      ],
      "Expiration": {
        "Days": 7
      }
    }
  ]
}
```

4. **Apply the Rule**:

```bash
aws s3api put-bucket-lifecycle-configuration \
  --bucket my-lifecycle-demo \
  --lifecycle-configuration file://lifecycle.json
```

5. **Validate**:

```bash
aws s3api get-bucket-lifecycle-configuration --bucket my-lifecycle-demo
```

---

## 📉 Monitoring and Logs

* Use **S3 Event Notifications** + **CloudWatch Logs** to monitor deletions.
* Enable **CloudTrail** to track object lifecycle operations.

---

## 📃 Best Practices

* Always **test on a dev bucket** before applying to production.
* Use **tags** for granular control.
* Keep object naming consistent to simplify prefix-based rules.

---

## 📅 Related Links

* [AWS Lifecycle Docs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html)
* [Storage Classes](https://aws.amazon.com/s3/storage-classes/)

---

**End of Guide** – You can now confidently create and test S3 Lifecycle Policies in your AWS environment.
