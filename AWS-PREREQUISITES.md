# AWS Deployment Prerequisites - HPC n8n AI Stack

> **Complete setup guide for deploying on AWS t3.small with Ubuntu 24.04 LTS**

## 🎯 **Overview**

This guide covers all AWS prerequisites needed before cloning the repository and running the deployment script. The stack is optimized for **AWS t3.small (2GB RAM, 1 vCPU)** instances.

---

## 📋 **AWS Account Requirements**

### **1. AWS Account Setup**
- [ ] **Active AWS Account** with billing configured
- [ ] **EC2 service access** (usually included in free tier)
- [ ] **Route 53 access** (if using custom domains)
- [ ] **IAM permissions** for EC2 management

### **2. Cost Estimation**
```
AWS t3.small (us-east-1):
- Instance: ~$16.79/month (730 hours)
- Storage: ~$2.00/month (20GB gp3)
- Data Transfer: ~$1.00/month (minimal)
- Route 53: ~$0.50/month (if using domains)

Total: ~$20-25/month
```

---

## 🖥️ **EC2 Instance Setup**

### **Step 1: Launch Instance**

#### **Instance Configuration:**
```
AMI: Ubuntu Server 24.04 LTS (ami-0e2c8caa4b6378d8c)
Instance Type: t3.small
Architecture: x86_64 (64-bit)
vCPUs: 1
Memory: 2.0 GiB
Storage: 20-30 GB gp3 (recommended)
Network: Default VPC (or custom)
```

#### **In AWS Console:**
1. **Go to EC2 Dashboard** → Launch Instance
2. **Name**: `hpc-n8n-ai-server`
3. **Application and OS**: Ubuntu Server 24.04 LTS
4. **Instance Type**: t3.small
5. **Key Pair**: Create new or select existing
6. **Security Group**: Create or configure (see below)
7. **Storage**: 20 GB gp3 SSD (minimum)
8. **Advanced Details**: Default settings

### **Step 2: Security Group Configuration**

#### **Required Inbound Rules:**
| Type | Protocol | Port Range | Source | Description |
|------|----------|------------|---------|-------------|
| SSH | TCP | 22 | Your IP | SSH access |
| HTTP | TCP | 80 | 0.0.0.0/0 | HTTP traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | HTTPS traffic |
| Custom TCP | TCP | 8001-8006 | Your IP | Development access (optional) |

#### **AWS CLI Command:**
```bash
# Create security group
aws ec2 create-security-group \
  --group-name hpc-n8n-ai-sg \
  --description "Security group for HPC n8n AI Stack"

# Add SSH rule
aws ec2 authorize-security-group-ingress \
  --group-name hpc-n8n-ai-sg \
  --protocol tcp \
  --port 22 \
  --cidr $(curl -s https://checkip.amazonaws.com)/32

# Add HTTP/HTTPS rules
aws ec2 authorize-security-group-ingress \
  --group-name hpc-n8n-ai-sg \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
  --group-name hpc-n8n-ai-sg \
  --protocol tcp \
  --port 443 \
  --cidr 0.0.0.0/0
```

### **Step 3: Key Pair Setup**

#### **Create New Key Pair:**
```bash
# Generate key pair
aws ec2 create-key-pair \
  --key-name hpc-n8n-ai-key \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/hpc-n8n-ai-key.pem

# Set correct permissions
chmod 400 ~/.ssh/hpc-n8n-ai-key.pem
```

#### **Connect to Instance:**
```bash
# Get instance public IP
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=hpc-n8n-ai-server" \
  --query 'Reservations[].Instances[].PublicIpAddress' \
  --output text

# SSH connect
ssh -i ~/.ssh/hpc-n8n-ai-key.pem ubuntu@YOUR_INSTANCE_IP
```

---

## 🌐 **Domain Setup (Optional but Recommended)**

### **Option 1: Route 53 Domain**

#### **Register Domain:**
```bash
# Check domain availability
aws route53domains check-domain-availability \
  --domain-name yourdomain.com

# Register domain (example)
aws route53domains register-domain \
  --domain-name yourdomain.com \
  --duration-in-years 1 \
  --auto-renew \
  --admin-contact file://contact.json \
  --registrant-contact file://contact.json \
  --tech-contact file://contact.json
```

#### **Create DNS Records:**
```bash
# Create hosted zone
aws route53 create-hosted-zone \
  --name yourdomain.com \
  --caller-reference $(date +%s)

# Add A records for subdomains
# n8n.yourdomain.com → Instance IP
# ai.yourdomain.com → Instance IP
# flowise.yourdomain.com → Instance IP
# etc.
```

### **Option 2: External Domain Provider**
If using Cloudflare, GoDaddy, or other providers:

1. **Point A records** to your EC2 instance public IP:
   ```
   n8n.yourdomain.com → 54.123.45.67
   ai.yourdomain.com → 54.123.45.67
   flowise.yourdomain.com → 54.123.45.67
   db.yourdomain.com → 54.123.45.67
   ```

2. **Set TTL to 300** seconds for faster DNS propagation

---

## 🔧 **Server Preparation**

### **Step 1: Connect to Your Instance**
```bash
# SSH into your EC2 instance
ssh -i ~/.ssh/hpc-n8n-ai-key.pem ubuntu@YOUR_INSTANCE_IP
```

### **Step 2: System Updates**
```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install -y \
  curl \
  wget \
  git \
  unzip \
  htop \
  ufw \
  python3 \
  python3-pip

# Verify Python version
python3 --version  # Should be 3.12+
```

### **Step 3: Docker Installation**
```bash
# Add Docker's official GPG key
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Log out and back in for group changes
exit
```

### **Step 4: Firewall Configuration**
```bash
# SSH back in
ssh -i ~/.ssh/hpc-n8n-ai-key.pem ubuntu@YOUR_INSTANCE_IP

# Configure UFW firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable firewall
sudo ufw --force enable

# Check status
sudo ufw status
```

### **Step 5: Verify Docker Installation**
```bash
# Test Docker installation
docker --version
docker compose version

# Test with hello-world
docker run hello-world
```

---

## 📧 **Email Configuration Prerequisites**

### **Gmail SMTP Setup**

#### **Step 1: Enable 2-Factor Authentication**
1. Go to **Google Account Settings** → **Security**
2. Enable **2-Step Verification**
3. Complete the setup process

#### **Step 2: Generate App Password**
1. **Google Account Settings** → **Security** → **2-Step Verification**
2. Scroll to **App passwords**
3. Select **Mail** → **Generate**
4. **Copy the 16-character password** (you'll need this for `.env`)

#### **Step 3: Note Configuration Values**
```bash
# Values needed for .env file:
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-16-char-app-password  # From step 2
SMTP_ADMIN_EMAIL=your-email@gmail.com
```

---

## 🔐 **Security Preparation**

### **Step 1: Generate Secure Keys**
```bash
# Generate n8n encryption keys (run on your local machine)
openssl rand -hex 32  # For N8N_ENCRYPTION_KEY
openssl rand -hex 32  # For N8N_USER_MANAGEMENT_JWT_SECRET
openssl rand -hex 32  # For JWT_SECRET
openssl rand -hex 32  # For VAULT_ENC_KEY

# Note these values for .env configuration
```

### **Step 2: Create Strong Passwords**
```bash
# Generate secure password for Supabase
openssl rand -base64 32

# Generate dashboard password
openssl rand -base64 16
```

---

## 🚀 **Ready to Deploy**

### **Deployment Checklist**
- [ ] **EC2 t3.small instance** running Ubuntu 24.04 LTS
- [ ] **Security group** configured with ports 22, 80, 443
- [ ] **Key pair** created and saved locally
- [ ] **Domain DNS** pointing to instance IP (if using SSL)
- [ ] **Docker installed** and user added to docker group
- [ ] **Firewall configured** with UFW
- [ ] **Email credentials** ready (Gmail app password)
- [ ] **Encryption keys generated** with OpenSSL

### **Now You Can Deploy:**
```bash
# 1. Clone repository
git clone https://github.com/highlandpc/hpc-n8n-ai.git
cd hpc-n8n-ai

# 2. Configure environment
cp .env.example .env
nano .env  # Update with your values

# 3. Deploy stack
python3 start_t3small.py

# 4. Access services
# n8n: http://your-ip:8001 (or https://n8n.yourdomain.com)
```

---

## 💡 **Cost Optimization Tips**

### **Stop Instance When Not Needed**
```bash
# Stop instance (keeps EBS storage)
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# Start instance
aws ec2 start-instances --instance-ids i-1234567890abcdef0
```

### **Use Elastic IP (Optional)**
```bash
# Allocate Elastic IP (prevents IP changes)
aws ec2 allocate-address --domain vpc

# Associate with instance
aws ec2 associate-address \
  --instance-id i-1234567890abcdef0 \
  --allocation-id eipalloc-12345678
```

---

## ⚠️ **Important Notes**

### **t3.small Limitations**
- **2GB RAM**: Cannot run large AI models
- **1 vCPU**: Limited concurrent processing
- **Burst performance**: Good for intermittent workloads
- **Network**: Up to 5 Gbps

### **Recommended Monitoring**
```bash
# Monitor memory usage
free -h
htop

# Monitor Docker resources
docker stats

# Check disk space
df -h
```

### **Backup Strategy**
- **EBS Snapshots**: For instance storage
- **Docker Volumes**: For application data
- **Configuration Files**: Store `.env` securely

---

## 🆘 **Troubleshooting**

### **Common Issues**

#### **SSH Connection Issues**
```bash
# Check security group allows SSH from your IP
# Verify key file permissions: chmod 400 key.pem
# Check instance is running: aws ec2 describe-instances
```

#### **Docker Permission Denied**
```bash
# Ensure user is in docker group
sudo usermod -aG docker $USER
# Log out and back in
```

#### **Memory Issues**
```bash
# Check memory usage
free -h
# Restart services if needed
docker compose restart
```

---

**Ready to deploy your AI stack on AWS?** Follow this guide step by step, then run `python3 start_t3small.py` to launch your HPC n8n AI Stack! 🚀