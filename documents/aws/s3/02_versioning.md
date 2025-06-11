# 📘 AWS S3 Versioning – Complete Guide

---

## 🧠 What is Versioning in S3?

Amazon S3 **versioning** is a feature that allows you to **preserve, retrieve, and restore every version** of every object stored in a bucket. When enabled, multiple versions of an object can exist in the same bucket.

> 🛡️ This is extremely useful for backup, audit, and recovery scenarios.

---

## 🔍 Behavior Comparison – With & Without Versioning

| Action                 | Versioning Disabled           | Versioning Enabled                      |
| ---------------------- | ----------------------------- | --------------------------------------- |
| Upload same file twice | Overwrites the old file       | Stores a **new version** of the object  |
| Delete an object       | Object is permanently deleted | A **delete marker** is placed           |
| Recover deleted file   | ❌ Not possible                | ✅ Restore by deleting the delete marker |
| List objects           | Only latest version is shown  | Optionally list all versions            |

---

## 🧾 How Versioning Works Internally

* Before enabling versioning:

  * S3 objects have **null version ID**.
* After versioning is turned on:

  * New uploads get a **unique version ID**.
  * Old objects retain the `null` version ID.
* Delete requests:

  * Place a **delete marker**, don't erase data.

> ⚠️ **Versioning is bucket-wide** and cannot be applied to individual objects.

---

## ✅ When to Use Versioning

| Use Case                     | Recommended? |
| ---------------------------- | ------------ |
| Backup & Recovery            | ✅ Yes        |
| Audit Trail / Compliance     | ✅ Yes        |
| Dev/Test Buckets             | 🚫 No        |
| Buckets with high overwrite  | ❌ Avoid      |
| Cost-sensitive archival data | ❌ Avoid      |

> 🧮 Tip: Versioning increases storage cost; use with Lifecycle Policies to delete older versions.

---

## ⚙️ Practical Step-by-Step Guide to Enable S3 Versioning

### 🔧 Step 1: Enable Versioning via AWS Console

1. Navigate to **S3 Console**.
2. Click on the bucket name (e.g., `my-app-data`).
3. Go to the **Properties** tab.
4. Scroll to **Bucket Versioning**.
5. Click **Edit** → Select **Enable** → Save changes.

### 📜 Step 2: Verify Versioning is Enabled

* Go to the **Objects** tab.
* Upload the same file (e.g., `logo.png`) twice.
* Click on the object → check **versions**.

### 💻 Step 3: Enable Using AWS CLI

```bash
aws s3api put-bucket-versioning \
  --bucket my-app-data \
  --versioning-configuration Status=Enabled
```

### 👁️ Step 4: List Object Versions

```bash
aws s3api list-object-versions --bucket my-app-data
```

### 🧼 Step 5: Setup Lifecycle Rule to Expire Old Versions

1. Go to the **Management** tab → Lifecycle rules.
2. Create a rule:

   * Filter: apply to all objects
   * Actions:

     * Expire previous versions after 30 days
     * Remove delete markers after 60 days

---

## 🚨 Caveats & Notes

* **Once enabled**, versioning cannot be fully disabled — only **suspended**.
* Enabling versioning on an existing bucket has **no impact on existing objects**.
* Object locking (for WORM storage) requires versioning to be **enabled first**.

---

## 📚 References

* [S3 Versioning Official Docs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html)
* [S3 Lifecycle Docs](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)

---

**End of Guide – You now know what S3 versioning is, when to use it, and how to implement and manage it effectively.**
