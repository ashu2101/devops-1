# 📊 **AWS CloudWatch Deep‑Dive Documentation**

*Comprehensive guide to monitoring, observability, and operational intelligence on AWS*

---

## 1 What Is Amazon CloudWatch?

Amazon CloudWatch is AWS’s native **observability platform**, collecting **metrics**, **logs**, **traces**, and **events** from nearly every AWS service and from on‑prem or hybrid workloads.  Key capabilities include:

* **Monitoring & Alerting** — real‑time dashboards, anomaly detection, alarms, composite alarms.
* **Logging & Analytics** — centralized log storage, Live Tail, CloudWatch Logs Insights, Contributor Insights.
* **Tracing & Application Monitoring** — ServiceLens integrations with AWS X‑Ray, RUM, Synthetics, Application Insights.
* **Event‑Driven Automation** — CloudWatch Events (now **Amazon EventBridge**) routes service events to Lambda, Step Functions, SNS, SQS, etc.

> 📚 **Docs:** [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)

---

## 2 Core Terminology

| Term              | Description                                                          |
| ----------------- | -------------------------------------------------------------------- |
| **Namespace**     | Isolates metric groups (e.g. `AWS/EC2`, `MyApp/Payments`).           |
| **Dimension**     | Key/value that identifies a metric source (e.g. `InstanceId=i‑123`). |
| **Log Group**     | Collection of log streams that share retention & permissions.        |
| **Log Stream**    | Sequence of log events from the same source (e.g., an EC2 instance). |
| **Alarm State**   | `OK`, `ALARM`, or `INSUFFICIENT_DATA`.                               |
| **Canary**        | Headless browser test in Synthetics that runs on a schedule.         |
| **Trace Segment** | Unit of work in X‑Ray; aggregated by ServiceLens.                    |

---

## 3 Metrics

### 3.1 Built‑In Metrics

Almost every AWS service publishes metrics to the `AWS/*` namespace at **1‑Minute** or **5‑Minute** resolution. Examples:

* `AWS/EC2 → CPUUtilization`
* `AWS/Lambda → Duration`, `Errors`, `Invocations`
* `AWS/ApplicationELB → TargetResponseTime`

### 3.2 High‑Resolution Metrics (1‑Second)

Use `StorageResolution=1` when pushing custom data (extra cost).  Helpful for real‑time scaling.

### 3.3 Metric Math

Combine / transform metrics using arithmetic, `RATE()`, `ANOMALY_DETECTION_BAND()`, `FILL()`, etc.
*Docs:* [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html)

### 3.4 Custom Metrics – Four Common Methods

| Method                            | How                                                                                                                       | Example                       |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| **PutMetricData API / CLI**       | `aws cloudwatch put-metric-data --namespace MyApp --metric-name CartAdds --value 1 --unit Count --dimensions Stage=prod`  | Useful in scripts.            |
| **CloudWatch Agent**              | `amazon-cloudwatch-agent.json` ➜ enables `StatsD`/`collectd` or native metrics (`mem_used_percent`, `disk_used_percent`). | Server & container telemetry. |
| **Embedded Metrics Format (EMF)** | Structured JSON logged to **CloudWatch Logs**; Lambda Powertools, AWS SDKs auto‑publish.                                  | Great for Lambda & ECS.       |
| **Auto‑Instrumentations**         | Container Insights, Lambda Telemetry API, RDS Enhanced Monitoring.                                                        | Turn‑key enablement.          |

> 🛠️ **Tip:** Tag custom metrics consistently (`Environment`, `Service`) for filterable dashboards.

---

## 4 Alarms

### 4.1 Standard Alarms

* Fixed static threshold or metric math expression.
* `Period` must align with the metric’s resolution.

### 4.2 Anomaly Detection Alarms

Creates a model with `ANOMALY_DETECTION_BAND(metric, 2)` to auto‑learn seasonality.  *Docs:* [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch\_Anomaly\_Detection.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Anomaly_Detection.html)

### 4.3 Composite Alarms

Combine multiple alarm states via boolean logic (`ALARM1 AND (ALARM2 OR ALARM3)`). Reduces alarm noise.  *Docs:* [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Composite\_Alarms.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Composite_Alarms.html)

### 4.4 Alarm Actions

| Action                      | Target Examples                       |
| --------------------------- | ------------------------------------- |
| **SNS Topic**               | Send email / SMS.                     |
| **Lambda**                  | Auto‑remediation scripts.             |
| **EC2 Auto Scaling Policy** | Scale Out/In.                         |
| **SSM OpsItem**             | Create operational item in OpsCenter. |

> 🔒 **Security Best Practice:** Use resource‑scoped IAM policies: `"Resource": "arn:aws:cloudwatch:us‑east‑1:123456789012:alarm:Prod*"`.

---

## 5 CloudWatch Logs

### 5.1 Ingestion Paths

* **Agent**: CloudWatch Agent, Fluent Bit, AWS Distro for OpenTelemetry.
* **Service Native**: Lambda, API Gateway, VPC Flow Logs, Route 53 Resolver, ALB.
* **PutLogEvents API**: Custom ingestion.

### 5.2 Key Components

| Component                | Details                                                                  |
| ------------------------ | ------------------------------------------------------------------------ |
| **Retention**            | 1 day to Infinite; set at Log Group level.                               |
| **Subscription Filters** | Stream in near‑real‑time to Lambda, Kinesis, Firehose, or cross‑account. |
| **Metric Filters**       | Convert log patterns to CloudWatch metrics.                              |
| **Live Tail**            | Real‑time viewer in console (up to 10 MB/min).                           |
| **Logs Insights**        | SQL‑like query language; charged per GB scanned.                         |

Sample Insights query – top 5 URLs:

```sql
fields @timestamp, @message
| parse @message "GET * HTTP/1.1" as url
| stats count(*) as hits by url
| sort hits desc
| limit 5;
```

### 5.3 Contributor Insights for Logs

Detect top‑N contributors causing spikes (e.g., noisy IPs).  *Docs:* [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContributorInsights.html)

---

## 6 Dashboards

* **Widgets**: Line, stacked area, number, text, query (Logs Insights), Synthetics canary status.
* **JSON Template**: Dashboards are just JSON; version‑control in Git.
* **Sharing**: Cross‑account / public read‑only (with IAM).
  *Docs:* [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch\_Dashboards.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html)

### Example JSON Snippet

```json
{
  "widgets": [
    {
      "type": "metric",
      "x": 0, "y": 0, "width": 12, "height": 6,
      "properties": {
        "metrics": [[ "AWS/EC2", "CPUUtilization", "InstanceId", "i-123" ]],
        "period": 60,
        "title": "EC2 CPU"
      }
    }
  ]
}
```

---

## 7 Events – Amazon EventBridge (CloudWatch Events)

* **Rules** evaluate events in JSON; cron (`rate(5 minutes)`) or pattern (`source=["aws.ec2"]`).
* **Targets**: Lambda, Step Functions, Kinesis, SQS, SNS, API destinations.
* **Event Bus**: Default, custom, partner; supports cross‑account sharing.
  *Docs:* [https://docs.aws.amazon.com/eventbridge/latest/userguide/eb.html](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb.html)

---

## 8 Synthetic Monitoring (CloudWatch Synthetics)

* **Canaries** run headless Chrome/Node.js every X minutes.
* Capture screenshots, HAR files; write metrics (`Failed`, `Duration`).
* Alarm on canary failures.

---

## 9 Real User Monitoring (CloudWatch RUM)

* JavaScript snippet instruments browser sessions.
* View page load performance, Core Web Vitals, Geo reports.

---

## 🔟 Application Insights

* 1‑click setup for **EC2**, **ECS**, **EKS**, **Lambda** stacks.
* Auto‑detects issues (memory leak, high latency) and surfaces them in **Problems** tab.

---

## 11 ServiceLens & X‑Ray Tracing

* Correlates CloudWatch metrics, logs, and **X‑Ray** traces in a single **Service Map**.
* Requires X‑Ray SDK or ADOT instrumentation.

---

## 12 Container & Serverless Observability

| Feature                  | Use Case                                                                        |
| ------------------------ | ------------------------------------------------------------------------------- |
| **Container Insights**   | ECS, EKS, K8s on EC2/Fargate – CPU, memory, network and **Prometheus** metrics. |
| **Lambda Telemetry API** | Native logs/metrics/traces via Lambda Layer (EMF).                              |

---

## 13 Pricing & Quotas (Highlights)

| Item               | Price                       | Note                            |
| ------------------ | --------------------------- | ------------------------------- |
| **Custom Metrics** | \$0.30 per metric per month | HR: \$0.3024 (per 1‑sec metric) |
| **Logs Ingestion** | \$0.50 per GB ingested      | Storage \$0.03 per GB‑month     |
| **Logs Insights**  | \$0.005 per GB scanned      | Free 5 GB / month               |

> Use **metric filters** instead of pushing duplicate metrics.  Apply log retention to control cost.

---

## 14 Security Best Practices

* Enable **VPC Endpoint for CloudWatch Logs** to keep traffic in AWS backbone.
* Encrypt Logs Groups with AWS‑KMS CMK.
* Use **Resource Policies** for cross‑account log subscriptions.
* Enforce least privilege IAM (e.g., `cloudwatch:PutMetricData` scoped by namespace).

---

## 15 CLI & Automation Pointers

| Task              | CLI Command                                                                                                                                                                                                                                                        |             |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| Put custom metric | `aws cloudwatch put-metric-data --namespace MyApp --metric-name Latency --value 120 --unit Milliseconds`                                                                                                                                                           |             |
| Create alarm      | `aws cloudwatch put-metric-alarm --alarm-name HighCPU --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 80 --comparison-operator GreaterThanOrEqualToThreshold --evaluation-periods 2 --alarm-actions arn:aws:sns:...` |             |
| Query logs        | \`aws logs start-query --log-group-name app --start-time 1690000000 --end-time 1690000600 --query-string 'fields @timestamp, @message                                                                                                                              | limit 20'\` |

Terraform resources: `aws_cloudwatch_metric_alarm`, `aws_cloudwatch_log_group`, `aws_cloudwatch_dashboard`, `aws_cloudwatch_event_rule`.

---

## 16 Quick Reference Documentation Links

* Metrics: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working\_with\_metrics.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)
* Custom Metrics: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html)
* Alarms: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)
* Logs: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)
* Logs Insights: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL\_QuerySyntax.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html)
* Dashboards: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch\_Dashboards.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html)
* EventBridge: [https://docs.aws.amazon.com/eventbridge/latest/userguide/eb.html](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb.html)
* Synthetics: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch\_Synthetics.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics.html)
* RUM: [https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch\_RUM.html](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_RUM.html)
* Pricing: [https://aws.amazon.com/cloudwatch/pricing/](https://aws.amazon.com/cloudwatch/pricing/)

---

### 🏁 Conclusion

Amazon CloudWatch is a **foundational observability service** spanning metrics, logs, traces, events, and synthetic monitoring. Mastering its components—**Metrics, Alarms, Logs, Dashboards, Events, Synthetics, Application Insights, ServiceLens**—enables proactive detection, rapid troubleshooting, and automated remediation of issues across your AWS workloads.
