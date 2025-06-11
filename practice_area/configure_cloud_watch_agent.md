Here are **detailed steps** to install and configure **CloudWatch Agent on an EC2 instance** to monitor:

* ✅ **Logs**
* ✅ **Memory**
* ✅ **Disk**

This guide includes both installation and manual configuration steps.

---

# 🛠️ Step-by-Step: CloudWatch Agent on EC2 (Logs, Memory, Disk)

---

## ✅ Prerequisites

* EC2 instance running Amazon Linux 2, Ubuntu, RHEL, or CentOS.
* IAM Role attached to EC2 with **CloudWatchAgentServerPolicy** permission.
* AWS CLI installed (usually available by default).

---

## 1️⃣ Attach IAM Role with CloudWatch Access

1. Go to **EC2 > Instances > Actions > Security > Modify IAM Role**.
2. Attach or create an IAM role with the following policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:*",
        "ec2:Describe*",
        "logs:*",
        "ssm:*"
      ],
      "Resource": "*"
    }
  ]
}
```

> Recommended managed policy: `CloudWatchAgentServerPolicy`

---

## 2️⃣ Install CloudWatch Agent

### On Amazon Linux 2 / RHEL / CentOS:

```bash
sudo yum install -y amazon-cloudwatch-agent
```

### On Ubuntu/Debian:

```bash
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb
```

---

## 3️⃣ Create CloudWatch Agent Configuration File

You can either generate it interactively or write manually.

### ✅ Option 1: Interactive Wizard

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

This will ask you:

* Region
* Metrics (CPU, memory, disk)
* Log files path
* Output (CloudWatch/SSM Parameter Store)
* Save location

It creates a file at `/opt/aws/amazon-cloudwatch-agent/bin/config.json`.

---

### ✅ Option 2: Manual Config File

Here’s a sample configuration to monitor:

* **Memory**
* **Disk (used\_percent)**
* **Logs from `/var/log/messages`**

Save this file as `/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json`:

```json
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "ec2-log-group",
            "log_stream_name": "{instance_id}-messages",
            "timestamp_format": "%b %d %H:%M:%S"
          }
        ]
      }
    }
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "metrics_collection_interval": 60,
        "resources": [
          "/"
        ]
      }
    }
  }
}
```

---

## 4️⃣ Start the CloudWatch Agent

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -s
```

This will fetch and start the agent with the config file.

---

## 5️⃣ Verify It’s Working

```bash
sudo systemctl status amazon-cloudwatch-agent
```

Check logs:

```bash
sudo tail -f /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
```

---

## 6️⃣ View Metrics and Logs in CloudWatch

* Go to **CloudWatch → Metrics → All Metrics → CWAgent**
* Logs will be under **Log Groups → /ec2-log-group** (or whatever you named)

---

## 📋 Useful Notes

| Component | Key Config Element                      |
| --------- | --------------------------------------- |
| Memory    | `"mem"` under `metrics_collected`       |
| Disk      | `"disk"` under `metrics_collected`      |
| Logs      | `logs_collected > files > collect_list` |
| Interval  | `metrics_collection_interval` (seconds) |

---

## 🔁 Auto Start on Reboot

CloudWatch agent is installed as a systemd service. It auto-starts by default:

```bash
sudo systemctl enable amazon-cloudwatch-agent
```

---
