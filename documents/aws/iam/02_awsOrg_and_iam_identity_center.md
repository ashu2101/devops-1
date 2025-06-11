
**AWS Organizations and IAM Identity Center (Formerly AWS SSO) - Deep Dive Documentation**

---

### 1. **Overview**

**AWS Organizations** allows you to centrally manage and govern multiple AWS accounts. It supports account grouping, centralized billing, service control policies (SCPs), and consolidated auditing.

**IAM Identity Center** (previously AWS Single Sign-On) provides centralized identity management and access control for AWS accounts and applications. It enables secure access using workforce credentials from identity providers like Microsoft AD, Okta, or built-in directory.

---

### 2. **AWS Organizations**

#### 2.1 Features

* **Account Management**: Create and manage multiple AWS accounts under one organization.
* **Service Control Policies (SCPs)**: Define guardrails that apply to accounts or organizational units (OUs).
* **Consolidated Billing**: Unified billing for all accounts.
* **Organizational Units (OUs)**: Group accounts for easier management and policy application.
* **Tag Policies**: Define rules for tagging AWS resources.
* **Delegated Admin**: Assign management responsibilities to member accounts.

#### 2.2 Key Concepts

* **Root**: The parent container of all OUs and accounts.
* **Organizational Units (OUs)**: Hierarchical groupings of accounts.
* **Accounts**: Either the management account or member accounts.
* **SCPs**: Policies that restrict account permissions (not grant them).

#### 2.3 Step-by-Step Setup

1. **Create Organization**:

   * Go to AWS Organizations console.
   * Click “Create an organization”.
   * Choose “Consolidated Billing” or “All Features” (recommended).
2. **Add Accounts**:

   * Invite existing AWS accounts.
   * Or create new accounts from the console.
3. **Create OUs**:

   * Navigate to "Organize accounts".
   * Click "Add an OU".
4. **Attach SCPs**:

   * Create SCP under "Policies" tab.
   * Attach to OUs or individual accounts.
5. **Enable Trusted Access** (for integration with services like IAM Identity Center, AWS Config, etc.)

#### 2.4 Best Practices

* Use OUs for environment separation (dev, staging, prod).
* Always apply SCPs to restrict overly permissive actions.
* Monitor with AWS CloudTrail and Config.
* Enable AWS Config organization-wide.

---

### 3. **IAM Identity Center**

#### 3.1 Features

* **SSO to AWS Console & CLI**
* **Access to Applications (SaaS)**
* **Integration with Identity Providers (IdPs)**
* **Centralized User and Permission Management**
* **Custom Permission Sets**

#### 3.2 Key Concepts

* **Identity Source**:

  * IAM Identity Center directory (default)
  * External IdPs via SAML (e.g., Okta, Azure AD)
* **Users and Groups**: Centralized identities for access management.
* **Permission Sets**: Define access roles and policies across AWS accounts.
* **Assignments**: Mapping between users/groups and permission sets in accounts.

#### 3.3 Step-by-Step Setup

1. **Enable IAM Identity Center**:

   * Go to IAM Identity Center Console.
   * Click "Enable" and select an identity source.
2. **Add Users and Groups**:

   * In "Users" tab, create or import users/groups.
3. **Create Permission Sets**:

   * Click on "Permission Sets".
   * Use predefined templates or custom JSON policies.
4. **Assign Access**:

   * Navigate to "AWS Accounts".
   * Choose account > Assign user/group > Select permission set.
5. **Configure SSO Apps (Optional)**:

   * Under “Applications”, add SAML integrations.
6. **CLI Access**:

   * Use AWS CLI v2 and `aws sso login`.

#### 3.4 IAM Identity Center vs IAM

| Feature                    | IAM Identity Center     | IAM                   |
| -------------------------- | ----------------------- | --------------------- |
| Centralized Access Control | ✅                       | ❌ (Per-account basis) |
| Identity Federation        | ✅ SAML + OIDC           | ✅ SAML                |
| Fine-grained permissions   | ✅ (via Permission Sets) | ✅ IAM Policies        |
| SSO for AWS Console        | ✅                       | ❌                     |

#### 3.5 Best Practices

* Always prefer using IAM Identity Center for organizations with multiple AWS accounts.
* Integrate with your enterprise IdP for centralized authentication.
* Define roles based on least privilege principle.
* Regularly audit assignments and permission sets.

---

### 4. **Integration Between AWS Organizations and IAM Identity Center**

IAM Identity Center integrates seamlessly with AWS Organizations to allow unified access management across all member accounts.

**Steps**:

1. Ensure AWS Organizations is using "All Features".
2. Enable IAM Identity Center in the management account.
3. Select accounts or OUs for permission assignment.
4. Assign permission sets from the management account.

---

### 5. **Useful Links**

* [AWS Organizations Docs](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)
* [IAM Identity Center Docs](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)
* [SCP Examples](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps_examples.html)
* [IAM Identity Center CLI Setup](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)

---

### 6. **Summary**

* **AWS Organizations** helps with account governance, SCP enforcement, and centralized management.
* **IAM Identity Center** simplifies identity and access control across multiple AWS accounts and applications.
* Together, they help enterprises enforce scalable, secure, and centralized cloud access management.


# AWS Organizations and IAM Identity Center (formerly AWS SSO) – Deep Dive

---

## 📘 Overview

### 🔹 AWS Organizations

AWS Organizations allows you to centrally manage and govern multiple AWS accounts. It enables policy-based management using Service Control Policies (SCPs), consolidated billing, and automated account creation.

### 🔹 IAM Identity Center (formerly AWS SSO)

IAM Identity Center is a cloud-based single sign-on service that allows you to centrally manage SSO access and user permissions across AWS accounts and applications.

---

## 🧩 AWS Organizations – Key Concepts

### 1. **Organization Root**

The top-level node in the hierarchy. All accounts are part of the root by default.

### 2. **Organizational Units (OUs)**

Logical groupings of AWS accounts. Policies can be applied to OUs.

### 3. **Service Control Policies (SCPs)**

Define maximum available permissions for accounts. They don't grant permissions directly but act as guardrails.

### 4. **Member Accounts**

Accounts that are part of the organization. Can be created or invited to join.

### 5. **Consolidated Billing**

All charges from member accounts roll up to the management account.

---

## 🧩 IAM Identity Center – Key Concepts

### 1. **Identity Source**

Options include AWS IAM Identity Center (built-in), Active Directory, or external IdPs (e.g., Okta, Azure AD).

### 2. **Users & Groups**

Manage identities in IAM Identity Center or sync from your identity provider.

### 3. **Permission Sets**

Define AWS permissions (policies) to be applied when users access accounts.

### 4. **Account Assignments**

Map users/groups to AWS accounts with specific permission sets.

---

## ✅ Step-by-Step Guide: Set up Developer Group with ReadOnly Permissions

### 🔧 Prerequisites:

* An AWS Organization already created.
* IAM Identity Center enabled.

---

### 🧾 Step 1: Enable IAM Identity Center

1. Go to AWS Console → **IAM Identity Center**.
2. Choose **Enable**.
3. Set up your **Identity Source** (use default IAM Identity Center).

---

### 👥 Step 2: Create a Developer Group and Users

1. Go to **IAM Identity Center > Users**.

2. Click **Add user**:

   * Username: `devuser1`
   * Email: your email
   * Set temporary password
   * Repeat for `devuser2`

3. Go to **Groups > Create Group**:

   * Group Name: `Developers`
   * Add `devuser1` and `devuser2` to this group

---

### 🧾 Step 3: Create a ReadOnly Permission Set

1. Go to **Permission Sets** > **Create Permission Set**.
2. Choose **Predefined Permission Set** → `ReadOnlyAccess`.
3. Name it: `Developer-ReadOnly`.
4. Optional: Add session duration, tags.
5. Create the permission set.

---

### 🔗 Step 4: Assign Group to AWS Account

1. Go to **AWS Accounts** in IAM Identity Center.
2. Select the account you want to assign access to.
3. Click **Assign users or groups**.
4. Choose Group: `Developers`
5. Choose Permission Set: `Developer-ReadOnly`
6. Click **Assign**.

---

### 🔍 Step 5: Test Access

1. Go to the **IAM Identity Center User Portal URL**.
2. Login with `devuser1` credentials.
3. Click on the account assigned.
4. You will be signed in with ReadOnly permissions.

---

## 📊 Monitoring and Auditing

* Use **CloudTrail** to log IAM Identity Center activity.
* **Access Analyzer** for validating permissions.

---

## 📚 References

* [AWS Organizations Docs](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html)
* [IAM Identity Center Docs](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)
* [Create Permission Set](https://docs.aws.amazon.com/singlesignon/latest/userguide/howtosetpermissions.html)

---

