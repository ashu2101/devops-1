# 🔐 AWS Security Groups - Detailed Guide

## 📌 Overview

A **Security Group** in AWS acts as a **virtual firewall** for your Amazon EC2 instances to control **inbound and outbound traffic**. You can assign one or more security groups to an instance when you launch it or modify it later.

---

## 🧱 Key Characteristics

### 1. **Stateful**

- If you allow an incoming request from a specific IP, the response traffic is automatically allowed.
- You don't need to explicitly define outbound rules for replies.

### 2. **Instance-Level Firewall**

- Security groups operate at the **instance level**, not the subnet level.

### 3. **Rules Are Evaluated As a Whitelist**

- Default deny: All traffic is denied unless allowed by rules
- Only allow rules can be configured (no deny rules)

### 4. **Applied at ENI Level**

- Security groups are associated with **Elastic Network Interfaces (ENIs)** attached to instances

---

## ⚙️ How Security Groups Work

### 🔁 Inbound Rules

- Define the allowed traffic coming into your instance
- Examples: Allow HTTP (port 80), SSH (port 22), etc.

### 🔁 Outbound Rules

- Define the allowed traffic going out of your instance
- Default: All outbound traffic is allowed

---

## 📊 Diagram: Security Group Functionality

```plaintext
+------------------+                    +-------------------+
|   Client (User)  |------------------> | EC2 Instance      |
| 203.0.113.0/24   |      Port 22      | with SG: WebSG     |
+------------------+       SSH         +-------------------+
                              ^
                              |
                  Inbound Rule in WebSG:
                      Protocol: TCP
                      Port: 22
                      Source: 203.0.113.0/24

Outbound (e.g. to internet) is allowed by default unless changed
```

---

## 🛠️ Security Group Configuration Options

| Setting        | Description                           |
| -------------- | ------------------------------------- |
| Name           | Name of the SG                        |
| Description    | Text describing purpose of SG         |
| VPC            | VPC to which the SG belongs           |
| Inbound Rules  | Allowed traffic sources and protocols |
| Outbound Rules | Allowed destinations and protocols    |
| Tags           | Key-value pairs for organization      |

---

## ✍️ Example Rules

### Inbound:

- Allow SSH:

  - Protocol: TCP
  - Port: 22
  - Source: `203.0.113.0/24`

- Allow HTTP:

  - Protocol: TCP
  - Port: 80
  - Source: `0.0.0.0/0`

### Outbound:

- Allow All Traffic:

  - Protocol: All
  - Port: All
  - Destination: `0.0.0.0/0`

---

## 🔁 Security Group Behavior

- **Multiple Security Groups per Instance**:

  - All rules from all attached SGs are aggregated (logical OR)

- **Multiple Instances per Security Group**:

  - Reuse SGs across multiple EC2 instances

- **Referencing Other Security Groups**:

  - Use a Security Group ID in source/destination to allow traffic between instances (e.g., ALB ↔ EC2)

---

## 🔐 Best Practices

1. **Least Privilege**: Only open the required ports/IPs
2. **Restrict SSH**: Use specific IPs, avoid 0.0.0.0/0
3. **Separate SGs**: Use separate SGs for web servers, databases, bastion hosts
4. **Tag SGs**: Organize by environment or purpose
5. **Use VPC Flow Logs**: For auditing traffic

---

## 📚 Summary

Security Groups are essential for securing EC2 and related services in AWS. They provide a flexible, instance-level firewall that is stateful and easy to manage. Proper use of security groups enhances your application’s security posture without introducing unnecessary complexity.
