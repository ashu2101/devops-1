# 📈 Understanding Auto Scaling Groups (ASG) in AWS

## ✅ What is an Auto Scaling Group?

An **Auto Scaling Group (ASG)** in AWS automatically manages a collection of Amazon EC2 instances. It allows your application to **scale out (add instances)** or **scale in (remove instances)** dynamically based on demand or policies.

---

## 🧩 Key Components of Auto Scaling

To configure an ASG, you need to understand and set up several components:

### 1\. **Launch Template (or Launch Configuration)**

- Defines how EC2 instances should be launched.

- Includes:

  - AMI ID (Amazon Machine Image)

  - Instance type (e.g., `t3.micro`)

  - Key pair

  - Security groups

  - EBS volumes

  - IAM instance profile (for access to S3, SSM, etc.)

  - User data script (for bootstrapping)

✅ **Launch Template** is preferred over Launch Configuration.

---

### 2\. **Auto Scaling Group (ASG)**

- Manages the group of EC2 instances.

- Key properties:

  - **Launch Template**

  - **VPC subnets** (must span AZs for HA)

  - **Min/Max/Desired instance count**

  - **Health check type** (EC2 or ELB)

  - **Load Balancer/Target Group** (optional)

  - **Scaling policies** (optional)

  - **Termination policies**

---

### 3\. **Scaling Policies (Optional)**

Define **how** and **when** the ASG should adjust the number of instances.

#### 🔹 Target Tracking Policy:

- E.g., Keep CPU utilization at 50%

#### 🔸 Step Scaling Policy:

- E.g., Add 2 instances if CPU > 80% for 5 minutes

#### 🔻 Scheduled Scaling:

- E.g., Increase instances at 8 AM and decrease at 8 PM

---

### 4\. **Health Checks**

- Monitors the health of instances.

- Types:

  - **EC2**: based on instance status checks

  - **ELB**: if behind Load Balancer, uses its health checks

- If an instance is unhealthy, ASG terminates and replaces it.

---

### 5\. **Load Balancer Integration (Optional but Recommended)**

- Use **Application Load Balancer (ALB)** or **Network Load Balancer (NLB)** with ASG.

- Benefits:

  - Load balances incoming traffic

  - Health checks help ASG determine instance status

  - Path-based routing support (with ALB)

---

### 6\. **Notifications (Optional)**

- Send SNS notifications on:

  - Instance launch

  - Instance terminate

  - Failures

---

## 🏗️ High-Level Flow

1.  **User defines a Launch Template**

2.  **ASG is created** using the template and attached to VPC subnets

3.  **Desired capacity is set** (e.g., 2 instances)

4.  **ASG launches instances** and maintains desired count

5.  **Scaling policies** adjust instances dynamically

6.  **Health checks** ensure only healthy instances remain

---

## 🛠️ Example Use Case

An e-commerce site needs:

- 2--6 EC2 instances

- Scaled based on CPU > 60%

- Load balanced

- Fault-tolerant across AZs

> Solution:
>
> - Launch Template with AMI, type, SG
>
> - ASG with min=2, max=6, desired=2
>
> - Target Tracking policy on CPU
>
> - ALB for traffic and health checks

---

## 🧾 Summary Table

| Component          | Purpose                                     |
| ------------------ | ------------------------------------------- |
| Launch Template    | Defines EC2 instance details                |
| Auto Scaling Group | Manages EC2 fleet scaling and lifecycle     |
| Scaling Policies   | Determines when/how to scale                |
| Load Balancer      | Distributes traffic, checks instance health |
| Notifications      | Sends alerts on ASG events (optional)       |
| Health Checks      | Monitors instance health (EC2/ELB)          |

---

## 📘 Bonus Tips

- Place EC2s in **multiple AZs** for high availability

- Use **SSM Agent + IAM role** for easier management without SSH

- Add **User Data** script in Launch Template for auto configuration

- Set **Cooldown periods** to prevent rapid scale-in/scale-out loops
