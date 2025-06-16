---
# 🔐 Project: Secure Static Website Hosting on AWS with S3 + CloudFront + Route 53 (No Public S3 Access)

## 🧠 Objective

Students will learn to:
  - Host a secure static website using a **private S3 bucket**
  - Distribute content publicly via **CloudFront**
  - Use **HTTPS** with a **custom domain** via **Route 53** and **ACM**
  - Block direct S3 access completely
---

## 🧰 Requirements

- AWS CLI configured (`aws configure`)
- `index.html` file ready
- Custom domain registered in Route 53
- IAM permissions to manage S3, CloudFront, ACM, Route 53

---

## 📘 Step-by-Step Tasks

---

### ✅ Task 1: Create a **Private S3 Bucket**

1. Go to **S3 → Create bucket**:

   - Name: `yourdomain.com`
   - Uncheck “ACLs”
   - **Keep “Block all public access” checked** (✅ Secure)
   - Enable versioning if needed

2. Upload `index.html` (and `error.html` if desired)

3. **Do NOT** add any bucket policy or make objects public

---

### ✅ Task 2: Create an SSL Certificate (HTTPS)

1. Go to **AWS Certificate Manager → Request Certificate**
2. Choose **Public certificate**
3. Add domain names:

   - `yourdomain.com`
   - `www.yourdomain.com`

4. Choose **DNS validation**
5. Add the validation **CNAME** records in **Route 53**
6. Wait until the certificate shows **“Issued”**

---

### ✅ Task 3: Create CloudFront Distribution with Secure Access

1. Go to **CloudFront → Create Distribution**

2. Under **Origin** settings:

   - Origin Domain: Choose your **S3 bucket (not website endpoint)** like `yourdomain.com.s3.amazonaws.com`
   - Origin Access: Select **“Origin access control settings (recommended)”**

     - Create a new Origin Access Control (OAC)
     - Name: `S3OAC-yourdomain`
     - Sign requests: `Yes`
     - Policy: `AWS managed`

3. Under **Default Cache Behavior**:

   - Viewer Protocol Policy: **Redirect HTTP to HTTPS**
   - Allowed Methods: `GET, HEAD`
   - Caching: Use default for now

4. Under **Settings**:

   - Alternate domain name (CNAME): `yourdomain.com`
   - SSL Certificate: Choose your **ACM-issued certificate**
   - Default Root Object: `index.html`

5. Click **Create Distribution** and note the CloudFront domain (e.g., `d1234abcd.cloudfront.net`)

---

### ✅ Task 4: Restrict S3 Bucket to CloudFront Only

1. Go to **S3 → your bucket → Permissions**
2. Click **Edit Bucket Policy**, and paste this policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontAccessOnly",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::yourdomain.com/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::YOUR_ACCOUNT_ID:distribution/DISTRIBUTION_ID"
        }
      }
    }
  ]
}
```

> Replace `YOUR_ACCOUNT_ID` and `DISTRIBUTION_ID` with actual values.

---

### ✅ Task 5: Configure Route 53

1. Go to **Route 53 → Hosted Zones → yourdomain.com**
2. Click **Create Record**
3. Choose:

   - Record name: `yourdomain.com`
   - Record type: **A**
   - Alias: **Yes**
   - Alias Target: Select the **CloudFront domain**

4. Repeat to add `www.yourdomain.com` if needed (with redirect or separate config)

---

### ✅ Task 6: Test and Verify

- Open `https://yourdomain.com`
- Verify:

  - ✅ S3 URL is blocked (try direct access to S3 file — should be denied)
  - ✅ CloudFront serves the content
  - ✅ HTTPS is enabled and working
  - ✅ Domain routes correctly via Route 53

---

## ✅ Deliverables for Students

- Website link (`https://yourdomain.com`)
- Screenshot of:

  - S3 bucket access settings (Block Public Access)
  - CloudFront distribution setup
  - Route 53 records
  - SSL certificate status in ACM

- Notes on:

  - Why public access is blocked
  - Why CloudFront is used
  - How security is enforced

---
