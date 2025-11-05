# AWS t3.small Optimization - Quick Start

## 🎯 Optimized for Ubuntu 24.04 LTS on AWS t3.small (2GB RAM)

This configuration includes **only** the required services with memory optimizations:

✅ **n8n** - Low-code platform (256MB limit)  
✅ **Supabase** - Database service (shared with existing limits)  
✅ **Ollama** - Local LLM platform (1.5GB limit, single model)  
✅ **Open WebUI** - Chat interface (256MB limit)  
✅ **Flowise** - AI agent builder (256MB limit)  
✅ **Qdrant** - Vector store (256MB limit)  
✅ **Caddy** - SSL/TLS proxy (64MB limit)  

## 🚀 Quick Start

```bash
# Start optimized stack
python3 start_t3small.py

# Check status
docker compose -f docker-compose.t3small.yml ps

# View logs
docker compose -f docker-compose.t3small.yml logs -f

# Stop services
docker compose -f docker-compose.t3small.yml down
```

## 📊 Memory Optimizations

- **Ollama**: Limited to 1 model, 4096 context length
- **All services**: Resource limits set for 2GB total RAM
- **Removed**: Neo4j, Langfuse, SearXNG, ClickHouse, Minio
- **Smaller models**: Uses llama3.1:8b-instruct-q4_K_M

## 🔧 Files Created

- `docker-compose.t3small.yml` - Optimized compose file
- `Caddyfile.t3small` - Minimal Caddy config  
- `start_t3small.py` - Optimized startup script
- `README-t3small.md` - This guide

## 🌐 Access Services

**Local Development:**
- n8n: http://localhost:5678
- Open WebUI: http://localhost:3000  
- Flowise: http://localhost:3001
- Supabase: http://localhost:8000
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