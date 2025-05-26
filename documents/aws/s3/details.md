🪵 1. Bucket Policies
✅ What It Is:
A JSON-based IAM policy attached at the bucket level.

Defines who (IAM users, accounts, services) can access the bucket and what actions they can perform (e.g., s3:GetObject, s3:PutObject).

✅ Key Features:
Supports fine-grained control (e.g., IP restrictions, time-based conditions).

Can grant cross-account access.

Replaces the need for complex ACLs.

✅ Example:
json
Copy
Edit
{
"Version": "2012-10-17",
"Statement": [
{
"Sid": "AllowPublicRead",
"Effect": "Allow",
"Principal": "*",
"Action": "s3:GetObject",
"Resource": "arn:aws:s3:::example-bucket/*"
}
]
}
✅ Best Used For:
Controlling access across AWS accounts

Managing access at the bucket level for multiple objects

🧾 2. Access Control Lists (ACLs)
✅ What It Is:
A legacy access control mechanism that defines permissions for:

Specific AWS accounts

Predefined groups (e.g., AllUsers for public access)

Applied at both bucket and object levels.

✅ Key Features:
Basic and limited — mainly read/write permissions

Not as flexible or secure as bucket policies

Can be used to grant object ownership across accounts

✅ Example:
json
Copy
Edit
{
"Owner": { ... },
"Grants": [
{
"Grantee": {
"Type": "Group",
"URI": "http://acs.amazonaws.com/groups/global/AllUsers"
},
"Permission": "READ"
}
]
}
✅ Best Used For:
Situations needing object-level permissions

Compatibility with legacy systems

📦 3. Object Permissions
✅ What It Is:
Permissions applied to individual S3 objects

Can be managed via:

ACLs

Bucket policies

IAM policies

✅ Key Features:
Inherits or overrides permissions from the bucket

Crucial for fine-grained access control

Supports access by IAM identities or external accounts

✅ Example:
A single object in a bucket can be made public using an object ACL

Or, access to it can be controlled via bucket policy with a path like arn:aws:s3:::my-bucket/myfile.jpg

🔍 Comparison Table
Feature Bucket Policy ACLs Object Permissions
Scope Bucket-wide Bucket/Object Object-specific
Format JSON XML (via AWS Console/API) JSON/ACL
Granularity High Low High
Cross-account support ✅ Yes ✅ Yes ✅ Yes
Best for new workloads ✅ Yes ❌ No (Legacy) ✅ Yes
Supports IAM conditions ✅ Yes ❌ No ✅ Yes (via bucket/IAM policies)
Block Public Access Scope Can override policy usage Can block ACLs Inherits from both

✅ Summary
Use Case Recommended Approach
Bucket-wide access control Bucket Policy
Object-level access in modern apps Object Permissions (via policy)
Legacy or cross-object ACL usage Access Control Lists (minimize use)
