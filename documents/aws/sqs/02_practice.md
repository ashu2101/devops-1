---
# 🚀 Hands-On Project: Amazon SQS + Lambda Integration
---

## 🧠 Objective

Create a system where:

1. A message is sent to an SQS queue.
2. AWS Lambda automatically gets triggered to process the message.

This mimics real-world use cases like order processing, background jobs, etc.

---

## 🧱 Project Architecture

```
+-----------+       +-------------+        +------------+
| Producer  | -->   | SQS Queue   |  -->   | Lambda Fn  |
| (CLI/API) |       | (my-queue)  |        | Processes  |
+-----------+       +-------------+        +------------+
```

---

## ✅ Prerequisites

- AWS account
- AWS CLI configured (`aws configure`)
- Basic IAM permissions to create Lambda, SQS, IAM roles, and CloudWatch

---

## 🛠️ Step-by-Step Setup

### Step 1: Create an SQS Queue

```bash
aws sqs create-queue --queue-name my-lambda-queue
```

### Step 2: Note the Queue ARN and URL

```bash
aws sqs get-queue-url --queue-name my-lambda-queue
aws sqs get-queue-attributes \
  --queue-url <QUEUE_URL> \
  --attribute-names QueueArn
```

---

### Step 3: Create an IAM Role for Lambda

Create a file called `trust-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "lambda.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

Create the role:

```bash
aws iam create-role \
  --role-name lambda-sqs-role \
  --assume-role-policy-document file://trust-policy.json
```

Attach policies:

```bash
aws iam attach-role-policy --role-name lambda-sqs-role \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

aws iam attach-role-policy --role-name lambda-sqs-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonSQSFullAccess
```

---

### Step 4: Create a Lambda Function

1. Save this code in a file called `lambda_function.py`:

```python
def lambda_handler(event, context):
    for record in event['Records']:
        print("Message ID:", record['messageId'])
        print("Message Body:", record['body'])
    return {'status': 'Processed'}
```

2. Zip it:

```bash
zip function.zip lambda_function.py
```

3. Create the Lambda:

```bash
aws lambda create-function \
  --function-name SQSProcessor \
  --runtime python3.12 \
  --role arn:aws:iam::<YOUR_ACCOUNT_ID>:role/lambda-sqs-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip
```

---

### Step 5: Add SQS Trigger to Lambda

```bash
aws lambda create-event-source-mapping \
  --function-name SQSProcessor \
  --batch-size 1 \
  --event-source-arn <SQS_QUEUE_ARN>
```

> Replace `<SQS_QUEUE_ARN>` with the ARN from Step 2.

---

### Step 6: Send a Test Message to SQS

```bash
aws sqs send-message \
  --queue-url <QUEUE_URL> \
  --message-body "Hello from SQS!"
```

---

### Step 7: View Lambda Logs (CloudWatch)

```bash
aws logs describe-log-groups
aws logs describe-log-streams --log-group-name /aws/lambda/SQSProcessor
aws logs get-log-events \
  --log-group-name /aws/lambda/SQSProcessor \
  --log-stream-name <YOUR_STREAM_NAME>
```

---

## ✅ What You Learned

| Skill / Concept           | Covered |
| ------------------------- | ------- |
| SQS queue creation        | ✅      |
| IAM roles and permissions | ✅      |
| Lambda deployment via CLI | ✅      |
| Event source mapping      | ✅      |
| End-to-end integration    | ✅      |

---

## 📘 Bonus Ideas

- Connect API Gateway to send messages to SQS via REST endpoint.
- Add a **Dead Letter Queue (DLQ)** for failed messages.
- Scale Lambda concurrency based on queue size (using auto-scaling).
- Add retry logic or DLQ alarms via **CloudWatch**.

---
