# 🚀 Complete Guide to Host Apache Web Server on EC2 Behind Load Balancer in AWS Console

This document provides **step-by-step, detailed instructions** to:

* Launch EC2 instances in AWS Default VPC
* Install and configure Apache Web Server on each EC2
* Configure Target Group
* Create Application Load Balancer (ALB)
* Connect ALB to Target Group
* Verify the site via ALB DNS

---

## ❶1⃣ Launch Two EC2 Instances

### Step 1: Go to EC2 Console

* Navigate to AWS Console > **EC2** > **Instances**
* Click **Launch Instances**

### Step 2: Configure EC2 Instance (Repeat twice for 2 instances)

* **Name**: `web-server-1` (repeat as `web-server-2`)

* **Amazon Machine Image (AMI)**: Amazon Linux 2 AMI (HVM), SSD Volume Type

* **Instance type**: `t2.micro` (eligible for Free Tier)

* **Key pair (login)**: Choose existing key pair or create a new one

* **Network settings**:

  * VPC: Default VPC
  * Subnet: Select any subnet (e.g., us-east-1a for instance 1, us-east-1b for instance 2)
  * Auto-assign Public IP: **Enabled**

* **Firewall (security group)**:

  * Click **Edit security groups**
  * Create a new security group (e.g., `web-sg`)
  * Add rules:

    | Type | Protocol | Port | Source    |
    | ---- | -------- | ---- | --------- |
    | SSH  | TCP      | 22   | My IP     |
    | HTTP | TCP      | 80   | 0.0.0.0/0 |

* Click **Launch Instance**

* Repeat this process to launch the second EC2 instance

### Step 3: Wait for EC2 to be in Running state

---

## ❶2⃣ Install Apache Web Server on EC2

### Step 1: Connect to EC2

From the EC2 dashboard, click on instance > **Connect** > choose **SSH client**

```bash
ssh -i "your-key.pem" ec2-user@<EC2_PUBLIC_IP>
```

### Step 2: Install Apache

```bash
sudo yum update -y
sudo yum install -y httpd
```

### Step 3: Start and enable Apache

```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```

### Step 4: Add HTML page

```bash
echo "<h1>Web Server 1</h1>" | sudo tee /var/www/html/index.html
```

Repeat this step on the second instance with different content:

```bash
echo "<h1>Web Server 2</h1>" | sudo tee /var/www/html/index.html
```

---

## ❶3⃣ Create Target Group

### Step 1: Go to EC2 > Load Balancing > **Target Groups**

* Click **Create Target Group**
* **Choose target type**: **Instances**
* **Name**: `apache-tg`
* **Protocol**: HTTP
* **Port**: 80
* **VPC**: Default VPC
* Click **Next**

### Step 2: Register Targets

* From the list, select the two EC2 instances
* **Port**: 80
* Click **Include as pending**
* Click **Create target group**

---

## ❶4⃣ Create Application Load Balancer (ALB)

### Step 1: Go to EC2 > Load Balancers > **Create Load Balancer**

* Choose **Application Load Balancer**

### Step 2: Configure Load Balancer

* **Name**: `apache-alb`
* **Scheme**: Internet-facing
* **IP address type**: IPv4
* **Listeners**:

  * Protocol: HTTP
  * Port: 80

### Step 3: Configure Availability Zones

* **VPC**: Default VPC
* Select at least two subnets in different availability zones (e.g., us-east-1a, us-east-1b)

### Step 4: Configure Security Groups

* Create or choose a security group (e.g., `alb-sg`)
* Add rule:

  | Type | Protocol | Port | Source    |
  | ---- | -------- | ---- | --------- |
  | HTTP | TCP      | 80   | 0.0.0.0/0 |

### Step 5: Configure Routing

* Choose existing target group: `apache-tg`

### Step 6: Register Targets

* This step will auto-populate from the target group

### Step 7: Create Load Balancer

* Review and click **Create Load Balancer**

---

## ❶5⃣ Test Load Balancer

* Go to **Load Balancers** > `apache-alb`
* Copy the **DNS name** (e.g., `apache-alb-xxxxx.us-east-1.elb.amazonaws.com`)
* Open it in a browser:

```
http://apache-alb-xxxxx.us-east-1.elb.amazonaws.com
```

You should randomly see `Web Server 1` or `Web Server 2`

---

## ✔️ Optional Enhancements

### Enable Access Logs

* Go to ALB > **Description** tab > **Edit attributes**
* Enable **Access logs**, specify an S3 bucket

### Enable HTTPS (Recommended)

* Create an ACM Certificate (AWS Certificate Manager)
* Add HTTPS listener (port 443) to ALB
* Redirect HTTP to HTTPS

### Domain Setup (Optional)

* Use Route 53 or external DNS provider
* Point your domain to ALB DNS using a **CNAME record**

---

## 📆 Maintenance and Monitoring

* Use CloudWatch to monitor target health, HTTP codes, traffic
* Set up alarms for unhealthy hosts
* Patch EC2 instances regularly

---

This completes the full manual setup of Apache Web Servers on EC2 with an Application Load Balancer using AWS Console.
