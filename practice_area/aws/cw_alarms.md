To configure an **Amazon CloudWatch Alarm** to notify via **email** when **CPU usage exceeds 80%**, follow this **step-by-step guide**:

---

## ✅ Step 1: Create an SNS Topic for Notifications

SNS (Simple Notification Service) is used to send alerts via email, SMS, etc.

### 1.1 Open SNS in AWS Console:

* Go to **AWS Console** → **SNS** → **Topics** → **Create topic**

### 1.2 Create Topic:

* **Type:** Standard
* **Name:** `cpu-alarm-topic`
* Click **Create topic**

### 1.3 Subscribe Email to Topic:

* After creating the topic, click on it → **Create subscription**
* **Protocol:** Email
* **Endpoint:** Your email address (e.g., `admin@example.com`)
* Click **Create subscription**

> ⚠️ **Important:** You will get a **confirmation email** — click the link inside to confirm the subscription.

---

## ✅ Step 2: Create a CloudWatch Alarm for CPU Usage

### 2.1 Go to CloudWatch:

* **CloudWatch Console** → **Alarms** → **Create alarm**

### 2.2 Select Metric:

* Click **Select metric**
* Choose:

  * **Browse** → **EC2** → **Per-Instance Metrics**
  * Select your EC2 instance → check `CPUUtilization`
  * Click **Select metric**

### 2.3 Define Alarm:

* **Period:** 5 minutes (or 1 minute for real-time)
* **Threshold type:** Static
* **Whenever CPUUtilization is...** `Greater than` `80`
* **For...** `1 consecutive period`

### 2.4 Configure Actions:

* **In alarm state → send notification to:**

  * Select the SNS topic you created: `cpu-alarm-topic`

### 2.5 Name and Create:

* Name your alarm (e.g., `High-CPU-Alarm`)
* Click **Create alarm**

---

## ✅ Done!

Once configured:

* CloudWatch will monitor CPU usage.
* If it goes **above 80%**, the alarm triggers.
* SNS sends a notification email to the subscribed address.

---

## 🧪 Optional: Test the Alarm

1. SSH into your EC2 instance.
2. Run CPU-intensive command:

   ```bash
   yes > /dev/null &
   ```
3. Stop the CPU spike:
   ```bash
   pkill yes
   ```
3. Wait a few minutes and check CloudWatch.
4. You should receive an email when the threshold is breached.

---
