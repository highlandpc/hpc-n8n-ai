# 🚀 Minimal Deployment Instructions for AWS t3.small

## What Changed?

Due to memory constraints on t3.small (2GB RAM), we've simplified the deployment to only essential services:

- ✅ **n8n** - Workflow automation (512MB limit)
- ✅ **Flowise** - AI workflow builder (512MB limit)  
- ✅ **Caddy** - Automatic HTTPS (128MB limit)
- ✅ **Watchtower** - Auto-updates (64MB limit)

**Total memory usage: ~600MB** (leaving 1.4GB free for operations)

❌ Removed (too memory-intensive):
- Supabase stack (~1GB)
- Ollama/Open WebUI
- Qdrant vector database

---

## 🔧 Deployment Steps on AWS Server

### 1. Stop Current Deployment (if running)

```bash
cd ~/hpc-n8n-ai/local-ai-t3small-optimized
docker compose -p hpc-n8n-ai --profile cpu -f docker-compose.t3small.yml down
```

### 2. Clean Up Resources

```bash
# Remove stopped containers and free up memory
docker system prune -af --volumes

# Verify memory is freed
free -h
```

### 3. Pull Latest Changes

```bash
git pull origin main
```

### 4. Use Minimal Environment File

```bash
# Backup your current .env (has Supabase config)
cp .env .env.backup

# Use the minimal environment file
cp .env.minimal .env
```

### 5. Deploy Minimal Stack

```bash
# Run the deployment script
./deploy-minimal.sh
```

### 6. Verify Deployment

```bash
# Check containers are running
docker ps

# Check memory usage (should be ~600MB total)
docker stats --no-stream

# Check system memory
free -h
```

---

## 🌐 DNS Configuration

You only need 2 DNS records now (remove the others):

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | n8n | `YOUR_SERVER_IP` | ❌ OFF |
| A | flowise | `YOUR_SERVER_IP` | ❌ OFF |

**Remove these DNS records (no longer needed):**
- supabase.highlandpc.cc
- qdrant.highlandpc.cc  
- openwebui.highlandpc.cc
- ollama.highlandpc.cc

---

## 📊 Access Your Services

- **n8n**: https://n8n.highlandpc.cc
- **Flowise**: https://flowise.highlandpc.cc (login: HPC / Hpc75092)

---

## 🔍 Troubleshooting

### Check Service Status
```bash
docker ps
docker logs n8n
docker logs flowise
docker logs caddy
```

### Monitor Memory
```bash
# Live monitoring
docker stats

# System memory
free -h
```

### Restart Services
```bash
docker compose -p hpc-n8n-ai -f docker-compose.minimal.yml restart
```

### Start Fresh
```bash
docker compose -p hpc-n8n-ai -f docker-compose.minimal.yml down
docker system prune -af
./deploy-minimal.sh
```

---

## 🔄 Auto-Updates

Watchtower will automatically update containers every **Sunday at 3 AM** with:
- Rolling restarts (one at a time)
- Old image cleanup
- 60-second timeout per container

---

## 💡 Future Scaling

When you need the full stack (Supabase, Ollama, etc.), consider upgrading to:

- **t3.medium** (4GB RAM, 2 vCPU) - $30/month
- **t3.large** (8GB RAM, 2 vCPU) - $60/month

Then you can use the full `docker-compose.t3small.yml` configuration.

---

## 📝 Quick Reference

| Command | Purpose |
|---------|---------|
| `./deploy-minimal.sh` | Deploy/redeploy stack |
| `docker ps` | List running containers |
| `docker logs <service>` | View service logs |
| `docker stats` | Monitor resource usage |
| `free -h` | Check system memory |
| `git pull origin main` | Get latest updates |

---

## ⚠️ Important Notes

1. **Memory**: This configuration uses ~600MB, leaving plenty of headroom
2. **SSL**: Caddy will automatically get Let's Encrypt certificates
3. **Data**: All data persists in Docker volumes (survives restarts)
4. **Backups**: Consider backing up Docker volumes regularly
5. **Monitoring**: Check `docker stats` occasionally to ensure no memory leaks

---

**Need help?** Check logs with `docker logs <container-name>`
