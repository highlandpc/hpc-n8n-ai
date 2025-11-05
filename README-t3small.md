# HPC n8n AI Stack - AWS t3.small Optimization

> **Memory-optimized deployment for AWS t3.small (2GB RAM) with Ubuntu 24.04 LTS**

## 🎯 **What's Included**

This optimized configuration includes **only essential services** with strict memory limits:

| Service | Purpose | Memory Limit | Access |
|---------|---------|--------------|---------|
| **n8n** | Workflow automation | 256MB | `:8001` |
| **Supabase** | Database backend | Shared pool | `:8005` |
| **Ollama** | Local AI models | 1536MB | `:8006` |
| **Open WebUI** | AI chat interface | 256MB | `:8002` |
| **Flowise** | AI workflow builder | 256MB | `:8003` |
| **Qdrant** | Vector database | 256MB | `:8004` |
| **Caddy** | SSL reverse proxy | 64MB | `:80/:443` |

**Total RAM Usage: ~1.8GB** (leaving 200MB for system overhead)

## 🚀 **Quick Deployment**

### **Step 1: Configure Environment**
```bash
# Copy and edit environment file
cp .env.example .env
nano .env

# Update these critical values:
# - N8N_ENCRYPTION_KEY (generate with: openssl rand -hex 32)
# - N8N_USER_MANAGEMENT_JWT_SECRET (generate with: openssl rand -hex 32)
# - POSTGRES_PASSWORD (set secure password)
# - Email SMTP settings (if using email features)
```

### **Step 2: Deploy Stack**
```bash
# Run optimized deployment script
python3 start_t3small.py

# Monitor startup progress
docker logs -f ollama  # Watch model downloads
```

### **Step 3: Verify Deployment**
```bash
# Check all services are running
docker compose -p hpc-n8n-ai -f docker-compose.t3small.yml ps

# Monitor memory usage
docker stats --no-stream
```

## 📊 **Memory Optimizations Applied**

### **Ollama Configuration**
- **Single model limit**: `OLLAMA_MAX_LOADED_MODELS=1`
- **Reduced context**: `OLLAMA_CONTEXT_LENGTH=4096` (vs 8192)
- **Quantized models**: Uses `llama3.2:3b` (3B parameters vs 8B)
- **Memory limit**: 1536MB hard limit

### **Service Resource Limits**
All services have Docker memory limits preventing OOM kills:
```yaml
deploy:
  resources:
    limits:
      memory: 256M
    reservations:
      memory: 128M
```

### **Removed Heavy Services**
- ❌ **Neo4j** (300MB+ graph database)
- ❌ **Langfuse** (500MB+ LLM observability)
- ❌ **ClickHouse** (400MB+ analytics DB)
- ❌ **MinIO** (200MB+ object storage)
- ❌ **SearXNG** (150MB+ search engine)

## 🔧 **File Structure**

### **Core Files**
- `docker-compose.t3small.yml` - Memory-optimized Docker Compose
- `start_t3small.py` - Sequential startup script
- `Caddyfile.t3small` - Minimal reverse proxy config
- `.env` - Environment configuration

### **Auto-Update System**
- `update_n8n.sh` - n8n update script with backup/rollback
- `setup_autoupdate.sh` - Configure automatic updates
- `check_autoupdate.sh` - Monitor update status
- `n8n-autoupdate.service` - Systemd service file
- `n8n-autoupdate.timer` - Weekly update schedule

## 🌐 **Service Access**

### **Local URLs (Development)**
```
n8n:           http://localhost:8001
Open WebUI:    http://localhost:8002  
Flowise:       http://localhost:8003
Qdrant:        http://localhost:8004
Supabase:      http://localhost:8005
Ollama API:    http://localhost:8006
```

### **Production URLs (with SSL)**
Configure domains in `.env` file:
```bash
N8N_HOSTNAME=n8n.yourdomain.com
WEBUI_HOSTNAME=ai.yourdomain.com
FLOWISE_HOSTNAME=flowise.yourdomain.com
SUPABASE_HOSTNAME=db.yourdomain.com
QDRANT_HOSTNAME=vector.yourdomain.com
OLLAMA_HOSTNAME=llm.yourdomain.com
LETSENCRYPT_EMAIL=admin@yourdomain.com
```

## 🛠️ **Management Commands**

### **Service Management**
```bash
# Start all services
python3 start_t3small.py

# Stop all services  
docker compose -p hpc-n8n-ai -f docker-compose.t3small.yml down

# Restart specific service
docker compose -p hpc-n8n-ai -f docker-compose.t3small.yml restart n8n

# View service logs
docker compose -p hpc-n8n-ai -f docker-compose.t3small.yml logs -f [service_name]
```

### **Monitoring**
```bash
# Check memory usage
docker stats --no-stream

# Check disk usage
df -h
docker system df

# View Ollama models
docker exec ollama ollama list
```

### **Troubleshooting**
```bash
# If memory issues occur
docker compose -p hpc-n8n-ai -f docker-compose.t3small.yml restart

# Clear unused Docker resources
docker system prune -f

# Check Ollama model download progress
docker logs ollama

# Reset n8n data (if needed)
docker volume rm hpc-n8n-ai_n8n_storage
```

## 🔒 **Security Considerations**

### **Required Before Production**
1. **Change default passwords** in `.env`
2. **Generate secure encryption keys** with `openssl rand -hex 32`
3. **Configure SSL certificates** with real domain names
4. **Enable firewall** on Ubuntu: `ufw enable`
5. **Set up monitoring** and log rotation

### **Recommended Security Headers**
Already configured in `Caddyfile.t3small`:
```
header Strict-Transport-Security "max-age=31536000;"
```

## ⚠️ **Known Limitations**

### **t3.small Constraints**
- **2GB RAM limit**: Cannot run multiple large models
- **1 vCPU**: Sequential processing only
- **Network performance**: Moderate bandwidth
- **Storage**: Uses EBS (slower than SSD)

### **Service Limitations**
- **Ollama**: Single 3B model only (llama3.2:3b)
- **Open WebUI**: Basic features only
- **Flowise**: Limited concurrent workflows
- **Qdrant**: Small vector storage capacity

## 📈 **Scaling Up**

### **Next Instance Size: t3.medium (4GB RAM)**
```bash
# Increase Ollama memory limit
OLLAMA_MAX_LOADED_MODELS=2

# Enable larger models
ollama pull llama3.2:8b  # 8B parameter model
```

### **Instance Size: t3.large (8GB RAM)**
```bash
# Re-enable additional services
# Uncomment in docker-compose.yml:
# - Neo4j (graph database)
# - Langfuse (LLM observability)

# Increase model capacity
OLLAMA_MAX_LOADED_MODELS=3
OLLAMA_CONTEXT_LENGTH=8192
```

## 🎯 **Deployment Checklist**

- [ ] **Environment configured**: `.env` file updated with secure values
- [ ] **Domain DNS**: A records pointing to server IP (if using SSL)
- [ ] **Firewall configured**: Ports 80, 443, 22 open
- [ ] **SSL email set**: `LETSENCRYPT_EMAIL` configured
- [ ] **Auto-updates configured**: `setup_autoupdate.sh` executed
- [ ] **Backup strategy**: Database and volume backup plan
- [ ] **Monitoring setup**: Resource usage alerts configured

## 🆘 **Support**

- **Repository**: [https://github.com/highlandpc/hpc-n8n-ai](https://github.com/highlandpc/hpc-n8n-ai)
- **Issues**: Create GitHub issue for bugs/features
- **Documentation**: Check `DEPLOYMENT-CHECKLIST.md` for detailed setup

---

**Ready to deploy?** Run `python3 start_t3small.py` and access your AI stack at the URLs above! 🚀
- Qdrant: http://localhost:6333

**Production with SSL:**
1. Configure domains in `.env`
2. Set DNS A records
3. Restart services

## � n8n Auto-Updates

Since n8n updates weekly, here are multiple auto-update options:

### Quick Setup
```bash
# Setup auto-updates (interactive)
./setup_autoupdate.sh

# Manual update anytime
./update_n8n.sh
```

### Auto-Update Methods

**1. 🐳 Watchtower (Recommended for Docker)**
```bash
# Enable Watchtower for automatic updates
docker compose -f docker-compose.t3small.yml --profile watchtower up -d watchtower

# Updates every Sunday at 2 AM automatically
# Includes image cleanup
```

**2. ⚙️ Systemd Timer (For system admins)**
```bash
# Setup as root user
sudo ./setup_autoupdate.sh

# Check timer status
systemctl status n8n-autoupdate.timer
```

**3. ⏰ Cron Job (User-level)**
```bash
# Add to crontab for weekly updates
0 2 * * 0 cd /path/to/local-ai-packaged && ./update_n8n.sh
```

### Update Features
- ✅ **Automatic backup** before updates
- ✅ **Health checks** after updates  
- ✅ **Rollback** on failure
- ✅ **Workflow preservation**
- ✅ **Credential backup** (encrypted)

## �💡 Production Setup

1. **Configure .env**:
```bash
N8N_HOSTNAME=n8n.yourdomain.com
WEBUI_HOSTNAME=openwebui.yourdomain.com
FLOWISE_HOSTNAME=flowise.yourdomain.com
SUPABASE_HOSTNAME=supabase.yourdomain.com
QDRANT_HOSTNAME=qdrant.yourdomain.com
LETSENCRYPT_EMAIL=admin@yourdomain.com
```

2. **Set DNS A records** pointing to your EC2 IP

3. **Restart services** to enable SSL