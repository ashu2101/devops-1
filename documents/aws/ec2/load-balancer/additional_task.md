Absolutely! Let's create a simple webpage that runs on an **Amazon Linux EC2 instance** and displays the following details:

- **Instance ID**
- **Availability Zone**
- **CPU Usage**
- **Memory Usage**

I'll break this into **steps** with code snippets.

---

## 🛠️ **Step 1: Install Required Tools on EC2**

Connect to your EC2 instance and install necessary packages:

```bash
sudo yum update -y
sudo yum install -y httpd jq curl
sudo systemctl enable --now httpd
```

---

## 🛠️ **Step 2: Create the Webpage Script**

We'll use a **shell script** that fetches instance metadata and system metrics, then generates an HTML page.

Create a file `/var/www/html/index.sh`:

```bash
sudo tee /var/www/html/index.sh > /dev/null <<'EOF'
#!/bin/bash

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Get CPU and memory usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_USAGE=$(awk "BEGIN {printf \"%.2f%%\", $MEM_USED/$MEM_TOTAL*100}")

# Generate HTML page
cat <<EOL > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>AWS Instance Info</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; background-color: #f4f4f4; padding-top: 50px; }
    h1 { color: #333; }
    p { font-size: 1.2em; }
    .card { background-color: white; display: inline-block; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
  </style>
</head>
<body>
  <div class="card">
    <h1>AWS EC2 Instance Info</h1>
    <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
    <p><strong>Availability Zone:</strong> $AZ</p>
    <p><strong>CPU Usage:</strong> $CPU_USAGE</p>
    <p><strong>Memory Usage:</strong> $MEM_USAGE</p>
  </div>
</body>
</html>
EOL
EOF
```

---

## 🛠️ **Step 3: Make the Script Executable and Schedule It**

```bash
sudo chmod +x /var/www/html/index.sh
sudo /var/www/html/index.sh
```

You can **refresh the data periodically** by adding a cron job:

```bash
(crontab -l 2>/dev/null; echo "*/1 * * * * /var/www/html/index.sh") | crontab -
```

This updates the page every 1 minute.

---

## 🛠️ **Step 4: Access the Webpage**

Open your browser and navigate to:

```
http://<EC2_PUBLIC_IP>/
```

You'll see your **Instance ID**, **Availability Zone**, **CPU Usage**, and **Memory Usage** displayed in a simple webpage.

---

## 🔒 **Optional: Secure the Page with a Security Group**

Allow only your IP to access port 80:

- Modify the EC2 Security Group:
  Inbound rules → HTTP (port 80) → Your IP (e.g., `203.0.113.0/32`).

---

## 🖥️ **Would you like a fully ready-to-deploy **CloudFormation** or **Terraform** module for this setup?**

Let me know, and I’ll prepare it for you! 🚀
