Here are the **complete steps to create a simple Python Flask app on an AWS EC2 machine** — including Python installation, app setup, and running it.

---

# 🚀 Deploy a Simple Python Flask App on EC2

---

## ✅ Prerequisites

* An EC2 instance (Amazon Linux 2 / RHEL / CentOS / Ubuntu)
* Security group allowing **port 80 (HTTP)** or **custom port like 5000**
* SSH access to EC2

---

## 🧩 Step 1: Connect to EC2

```bash
ssh -i your-key.pem ec2-user@<ec2-public-ip>
```

---

## 🐍 Step 2: Install Python and pip

> For Amazon Linux 2 / RHEL / CentOS:

```bash
sudo yum update -y
sudo yum install -y python3
sudo pip3 install --upgrade pip
```

> For Ubuntu:

```bash
sudo apt update -y
sudo apt install -y python3 python3-pip
```

---

## 📁 Step 3: Create Flask App Directory

```bash
mkdir ~/flask-app && cd ~/flask-app
```

---

## 🌱 Step 4: Create Python Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate
```

---

## 📦 Step 5: Install Flask

```bash
pip install flask
```

---

## 📝 Step 6: Write Flask App (`app.py`)

```bash
cat <<EOF > app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "✅ Hello from EC2 Flask App!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
EOF
```

---

## 🔥 Step 7: Run the Flask App

```bash
sudo nohup venv/bin/python app.py > /var/log/flask.log 2>&1 &
```

> ✅ App will be accessible at:
> **http\://<your-ec2-public-ip>/**

---

## 🔁 (Optional) Step 8: Run Flask App via systemd

To keep it running after reboot:

1. **Create systemd service file:**

```bash
sudo tee /etc/systemd/system/flaskapp.service > /dev/null <<EOF
[Unit]
Description=Flask App
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/flask-app
ExecStart=/home/ec2-user/flask-app/venv/bin/python app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF
```

2. **Enable and start the service:**

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl start flaskapp
```

---

## 📌 Final Checks

* Visit your EC2's **public IP** in the browser.
* Ensure your **security group** allows **port 80**.

---

Let me know if you'd like to:

* Use **Nginx** or **Gunicorn** for production.
* Run on **HTTPS** with SSL.
* Package this into a **Terraform module**.
