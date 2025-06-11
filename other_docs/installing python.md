Here's a detailed document explaining how to:

1. Install Python from **YUM (System Package Manager)**.
2. Install the **latest version of Python from source (official website)**.
3. Manage **multiple Python versions** and set the **default Python** to the latest one.
4. Create and use a **Python virtual environment** with the latest Python version.

---

# 🐍 Python Installation and Environment Setup Guide

---

## 📌 1. Install Python using YUM (System Package Manager)

> This will install the system-provided version, usually older.

```bash
sudo yum update -y
sudo yum install -y python3 python3-pip
```

### ✅ Verify Installation

```bash
python3 --version
pip3 --version
```

---

## 📌 2. Install Latest Python from Source (Official Website)

### 📁 Step 1: Install Required Dependencies

```bash
sudo yum groupinstall -y "Development Tools"
sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel wget make zlib-devel
```

### 🌐 Step 2: Download and Extract Python Source Code

```bash
cd /usr/src
sudo wget https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz
sudo tar xzf Python-3.11.9.tgz
cd Python-3.11.9
```

### ⚙️ Step 3: Compile and Install Python

```bash
sudo ./configure --enable-optimizations
sudo make altinstall  # Don't overwrite the system python
```

> 🔁 `make altinstall` installs `python3.11` and `pip3.11` safely without affecting system tools.

---

## 📌 3. Set Default Python to Latest Installed Version

### ✅ Check Installed Versions

```bash
ls /usr/local/bin/python*
ls /usr/bin/python*
```

### 🔗 Update the Default `python` Command

```bash
sudo alternatives --install /usr/bin/python python /usr/local/bin/python3.11 2
sudo alternatives --install /usr/bin/python python /usr/bin/python3 1
```

> 🧠 This sets up `python` to point to the latest version (priority 2 is higher than 1).

### 🔁 Switch Between Versions (Optional)

```bash
sudo alternatives --config python
# Select the Python version interactively
```

### ✅ Confirm

```bash
python --version
# Output: Python 3.11.9
```

---

## 📌 4. Create Virtual Environment Using Latest Python

### 📁 Create Project Directory

```bash
mkdir ~/my-python-app && cd ~/my-python-app
```

### 🌐 Create Virtual Environment

```bash
python -m venv venv
```

### ✅ Activate Environment

```bash
source venv/bin/activate
```

### 📦 Install Packages

```bash
pip install flask requests
```

### ❌ Deactivate Environment

```bash
deactivate
```

---

## 🧪 Optional: Alias for `pip`

```bash
alias pip="python -m pip"
```

Add to your `~/.bashrc` or `~/.bash_profile` if desired.

---

## 📝 Summary

| Task                 | Command / Result           |
| -------------------- | -------------------------- |
| Install from source  | `make altinstall`          |
| Set `python` default | `alternatives --install`   |
| Create virtual env   | `python -m venv venv`      |
| Activate venv        | `source venv/bin/activate` |
| Check Python version | `python --version`         |

---

