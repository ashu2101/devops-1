📘 Installing a Simple Web Server and Hosting an HTML Page on EC2
-----------------------------------------------------------------

This guide covers the steps to install a basic web server (Apache) and host a static HTML file (`index.html`) on an AWS EC2 instance.

* * * * *

### ✅ Prerequisites

-   An AWS EC2 instance (Amazon Linux or Ubuntu)

-   Port **80** open in the EC2 instance's security group

-   `index.html` file ready on your local machine

* * * * *

### 🚀 Step 1: Install Apache Web Server

#### 🔹 For **Amazon Linux**:

bash

CopyEdit

`sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd`

#### 🔹 For **Ubuntu**:

bash

CopyEdit

`sudo apt update
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2`

* * * * *

### 📂 Step 2: Upload Your HTML File

Use SCP or another method to upload `index.html` to your EC2 instance. Example using SCP:

bash

CopyEdit

`scp -i your-key.pem index.html ec2-user@<your-ec2-public-ip>:/tmp`

* * * * *

### 🛠 Step 3: Move the HTML File to Web Directory

On the EC2 instance:

bash

CopyEdit

`sudo mv /tmp/index.html /var/www/html/index.html`

* * * * *

### 🌐 Step 4: Access Your Web Page

Open your browser and go to:

cpp

CopyEdit

`http://<your-ec2-public-ip>/`

You should see your custom HTML page!
