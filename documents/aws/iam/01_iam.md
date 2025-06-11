# AWS IAM (Identity and Access Management) Deep Dive

## Overview

AWS IAM (Identity and Access Management) is a service that enables secure control of access to AWS services and resources. IAM lets you manage **users, groups, roles, and policies**, and provides granular permissions and authentication options.

---

## Key Components of IAM Dashboard

### 1. **Users**

* Represents individual IAM identities with long-term credentials.
* Users can belong to groups and be assigned permissions directly or through groups.

**Common Operations:**

* Create users with programmatic access (CLI, SDKs) or AWS Management Console access.
* Rotate access keys.
* Attach policies (AWS Managed, Customer Managed).

**Best Practice:**

* Do not use root user for daily tasks.
* Enable MFA for all users.

---

### 2. **Groups**

* Collection of IAM users.
* Used to manage permissions across multiple users efficiently.

**Example:**

* Developers group with access to EC2 and S3.

**Best Practice:**

* Use groups to simplify permission management.

---

### 3. **Roles**

* IAM entity that allows AWS services or applications to assume permissions.
* Temporary credentials are generated.

**Use Cases:**

* Cross-account access.
* EC2 instance role.
* Lambda execution role.
* Federated user access.

**Best Practice:**

* Define least privilege access.
* Rotate external Ids when sharing roles.

---

### 4. **Policies**

* Documents written in JSON to define permissions.
* **Managed Policies**: AWS Managed or Customer Managed.
* **Inline Policies**: Embedded directly into a user, group, or role.

**Example Policy Snippet:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::example-bucket"
    }
  ]
}
```

**Best Practice:**

* Prefer managed policies over inline policies.
* Use policy versioning.

---

### 5. **Identity Providers**

* Integrate external identity providers (IdPs) like:

  * SAML (for ADFS/Okta/Auth0)
  * OIDC (e.g., Cognito, Google)
  * Social IdPs (via Cognito)

**Use Case:**

* Federate on-premises AD with AWS.

**Guide:** [IAM Identity Providers](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html)

---

### 6. **Account Settings**

* Set password policy (length, expiration, complexity).
* Configure IAM access analyzer.
* Enable multi-factor authentication (MFA).

---

### 7. **Access Analyzer**

* Helps identify resources shared outside your account.
* Integrates with CloudTrail for traceability.

**Best Practice:**

* Enable Access Analyzer for each region.

---

### 8. **Credential Report**

* CSV report listing all IAM users and the status of their credentials (passwords, access keys, MFA).

**Command:**

```bash
aws iam generate-credential-report
aws iam get-credential-report
```

---

### 9. **Permissions Boundaries**

* Advanced feature to set maximum permission limit for IAM roles/users.
* Helps delegate IAM permissions without giving full admin rights.

**Use Case:**

* Limit what developers can do even if their policies are permissive.

---

### 10. **Session Policies**

* Advanced feature for temporary credentials.
* Attach a policy inline when assuming a role/session.

---

### 11. **Service-Linked Roles**

* Predefined roles that allow AWS services to perform actions on your behalf.

**Examples:**

* Amazon EC2 Auto Scaling
* AWS Elastic Beanstalk

**Guide:** [Service-linked roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html)

---

## IAM Best Practices

* **Enable MFA** for all IAM users and root account.
* **Use roles** instead of sharing credentials.
* **Grant least privilege** using managed policies.
* **Rotate access keys** regularly.
* **Monitor IAM usage** with CloudTrail and Access Analyzer.

---

## Common Automation & CLI Commands

* List users:

```bash
aws iam list-users
```

* Create user:

```bash
aws iam create-user --user-name dev-user
```

* Attach policy:

```bash
aws iam attach-user-policy --user-name dev-user --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```

* Create role:

```bash
aws iam create-role --role-name EC2S3Access --assume-role-policy-document file://trust-policy.json
```

---

## IAM Policy Simulator

* Tool to test and simulate policies to validate permissions.
* URL: [https://policysim.aws.amazon.com/](https://policysim.aws.amazon.com/)

---

## Useful Links

* [AWS IAM Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
* [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
* [IAM Policy Reference](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html)

---

Let me know if you want a companion doc on automating IAM using Terraform or CDK.
