# AWS Simple Notification Service (SNS) - Comprehensive Guide

---

## 🧭 What is AWS SNS?

**Amazon Simple Notification Service (SNS)** is a **fully managed publish-subscribe messaging service** that enables the **asynchronous communication** between decoupled components of distributed systems. SNS is ideal for building scalable, loosely coupled, event-driven architectures.

It allows applications, services, or devices (publishers) to send messages to a topic, and then SNS distributes those messages to subscribers of that topic through various protocols such as:

- Email
- SMS
- AWS Lambda
- Amazon SQS
- HTTP/HTTPS endpoints
- Mobile push notifications

---

## 🧱 Core Concepts & Components

### 1. **Topic**

- A communication channel used by publishers to send messages.
- Supports two types:

  - **Standard**: High throughput, at-least-once delivery, unordered.
  - **FIFO**: Preserved message order, exactly-once delivery (new feature).

### 2. **Publisher**

- Sends messages to an SNS topic.
- Can be applications, AWS services (CloudWatch, Lambda, etc.), or CLI/SDK users.

### 3. **Subscriber**

- Receives messages from a topic.
- Can be:

  - Email or Email-JSON
  - SMS
  - Amazon SQS
  - AWS Lambda
  - HTTP/HTTPS endpoint
  - Mobile applications (Push notifications)

### 4. **Subscription**

- Binds a topic to a subscriber endpoint and defines the delivery protocol.
- Some protocols (email, HTTP) require confirmation.

### 5. **Message**

- The payload sent by the publisher to the topic.
- Can include metadata (attributes) for filtering and processing.

### 6. **Access Policy**

- Resource-based policy defining who can publish or subscribe.
- Supports IAM, service principal, and cross-account access.

---

## 🔄 Message Flow

1. Topic is created.
2. One or more subscribers subscribe to the topic.
3. Publisher sends a message to the topic.
4. SNS fans out the message to all confirmed subscribers.

---

## 🚦 Standard vs FIFO Topics

| Feature           | Standard Topic    | FIFO Topic       |
| ----------------- | ----------------- | ---------------- |
| Message Order     | Not guaranteed    | Guaranteed       |
| Delivery Attempts | At least once     | Exactly once     |
| Throughput        | Very high         | Limited          |
| Use Cases         | Alerts, analytics | Payments, orders |

---

## 📡 Supported Protocols

- **Amazon SQS**
- **AWS Lambda**
- **HTTP/HTTPS**
- **Email / Email-JSON**
- **SMS**
- **Mobile Push** (via APNs, FCM)
- **Application (ARN for mobile apps)**

---

## 🔐 Access Control and Security

- Use **IAM policies** to control publishing rights.
- Apply **resource-based policies** on topics for fine-grained access.
- Use **AWS KMS** for message encryption at rest.
- Enable **delivery status logging** for debugging.

---

## 🧠 Advanced Features

### ✅ Message Filtering

- Subscribers can apply filter policies using message attributes.

```json
{
  "store": ["aws", "azure"]
}
```

### 📤 Delivery Retries

- HTTP/S: Exponential backoff retry policy.
- Lambda: Retry on invocation failure.

### ☠️ Dead-Letter Queues (DLQ)

- Capture undeliverable messages for troubleshooting.

### 🔐 Encryption

- Use customer-managed AWS KMS keys for encryption.

---

## 🧪 HANDS-ON LAB 1: Email Notification using SNS

### 🔧 Goal: Notify users via email when an event occurs.

#### Step 1: Create SNS Topic

1. Go to **AWS Console > SNS > Topics > Create Topic**
2. Choose **Standard**
3. Name: `email-alert-topic`
4. Click **Create Topic**

#### Step 2: Add Email Subscription

1. Inside topic, click **Create subscription**
2. Protocol: **Email**
3. Endpoint: `your-email@example.com`
4. Click **Create subscription**
5. Confirm email subscription from inbox

#### Step 3: Publish Message

1. Open the topic > **Publish message**
2. Subject: `Test Notification`
3. Message body: `This is a test message.`
4. Click **Publish**

✅ You should receive an email notification.

---

## 🧪 HANDS-ON LAB 2: SNS to Lambda Integration

### 🔧 Goal: Trigger a Lambda function from an SNS Topic.

#### Step 1: Create SNS Topic

1. Create a topic `lambda-notify-topic` (same as above)

#### Step 2: Create Lambda Function

1. Go to **AWS Console > Lambda > Create Function**
2. Name: `snsHandler`
3. Runtime: **Python 3.9**
4. Code:

```python
import json

def lambda_handler(event, context):
    print("Event received from SNS:", json.dumps(event))
    return {
        'statusCode': 200,
        'body': json.dumps('Received!')
    }
```

5. Deploy function

#### Step 3: Add Lambda as Subscriber

1. Go to SNS Topic → **Create subscription**
2. Protocol: **AWS Lambda**
3. Choose your function `snsHandler`
4. Click **Create subscription**

#### Step 4: Publish Message to Topic

- Send a message and verify Lambda logs in **CloudWatch Logs**

✅ SNS now triggers Lambda on new messages.

---

## 💼 Real-World Use Cases

| Use Case                     | Description                                          |
| ---------------------------- | ---------------------------------------------------- |
| **CloudWatch Alarms**        | Auto-notify via email/SMS when CPU > threshold       |
| **Fan-out Design**           | One topic → multiple SQS/Lambda consumers            |
| **Mobile App Notifications** | Push messages to iOS/Android devices                 |
| **Order System**             | Order → SNS → Lambda for invoice, SQS for processing |
| **CI/CD Pipeline Events**    | CodePipeline → SNS → Slack/Webhooks                  |

---

## 📈 Monitoring & Logging

- **CloudWatch Metrics**: Number of deliveries, failures, throttles
- **CloudTrail Logs**: API audit trail
- **Delivery Status Logging**: Enable via topic attributes

---

## 💸 Pricing Summary

| Feature             | Cost                   |
| ------------------- | ---------------------- |
| 1M publish requests | Free tier              |
| Email notifications | Free (SMTP)            |
| SMS in US           | \~\$0.0075 per message |
| Mobile push         | Free                   |

---

## 🧾 Resources

- [SNS Documentation](https://docs.aws.amazon.com/sns/)
- [SNS Pricing](https://aws.amazon.com/sns/pricing/)
- [SNS Workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/)
- [Message Filtering](https://docs.aws.amazon.com/sns/latest/dg/sns-message-filtering.html)

---

## ✅ Summary

AWS SNS enables **real-time**, **multi-protocol**, and **event-driven** messaging between distributed systems. With features like filtering, retry handling, DLQs, encryption, and integrations, SNS is a **cornerstone** for decoupled AWS architectures.
