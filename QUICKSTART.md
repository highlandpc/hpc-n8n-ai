# 🎯 Quick Start - Fresh AWS t3.small Instance

## Step 1: Connect to Your New Instance

```bash
ssh -i your-key.pem ubuntu@YOUR_NEW_IP
```

## Step 2: Run One-Line Setup

Copy and paste this **entire command** into your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/highlandpc/hpc-n8n-ai/main/local-ai-t3small-optimized/setup-fresh-instance.sh | bash
```

This will:
- ✅ Update Ubuntu
- ✅ Install Docker & Docker Compose
- ✅ Install Git
- ✅ Clone your repository
- ✅ Setup environment files

## Step 3: Log Out and Back In

```bash
exit
```

Then reconnect:
```bash
ssh -i your-key.pem ubuntu@YOUR_NEW_IP
```

## Step 4: Deploy

```bash
cd ~/hpc-n8n-ai/local-ai-t3small-optimized
./deploy-minimal.sh
```

## Step 5: Update DNS

In Cloudflare, update your DNS A records to point to **YOUR_NEW_IP**:

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | n8n | `YOUR_NEW_IP` | ❌ OFF |
| A | flowise | `YOUR_NEW_IP` | ❌ OFF |

Wait 2-5 minutes for DNS propagation, then access:
- **n8n**: https://n8n.highlandpc.cc
- **Flowise**: https://flowise.highlandpc.cc

---

## 🔧 AWS Security Group

Make sure your instance allows:

| Type | Port | Source | Description |
|------|------|--------|-------------|
| SSH | 22 | Your IP | SSH access |
| HTTP | 80 | 0.0.0.0/0 | HTTP (redirects to HTTPS) |
| HTTPS | 443 | 0.0.0.0/0 | HTTPS traffic |

---

## ✅ Verification

After deployment, check:

```bash
# Services running
docker ps

# Memory usage (~600MB expected)
docker stats --no-stream

# Logs
docker logs n8n
docker logs flowise
docker logs caddy
```

---

## 🎉 That's It!

Your minimal stack should be running with:
- Memory usage: ~600MB / 2GB (70% free)
- Auto-updates: Sundays at 3 AM
- Automatic HTTPS with Let's Encrypt

**Total setup time: ~10 minutes** ⚡
