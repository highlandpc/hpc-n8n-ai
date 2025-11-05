# 🚀 Pre-Deployment Checklist for AWS t3.small

## ✅ Files You MUST Update Before Deployment

### 1. **`.env` - CRITICAL Security Configuration**

**REQUIRED Changes** (these use default/example values):

```bash
# Generate secure keys first:
openssl rand -hex 32  # Use this output for the keys below

# Required n8n credentials
N8N_ENCRYPTION_KEY=super-secret-key                    # ❌ CHANGE THIS
N8N_USER_MANAGEMENT_JWT_SECRET=even-more-secret        # ❌ CHANGE THIS

# Required Supabase credentials  
POSTGRES_PASSWORD=your-super-secret-and-long-postgres-password  # ❌ CHANGE THIS
JWT_SECRET=your-super-secret-jwt-token-with-at-least-32-characters-long  # ❌ CHANGE THIS
DASHBOARD_PASSWORD=this_password_is_insecure_and_should_be_updated  # ❌ CHANGE THIS
POOLER_TENANT_ID=your-tenant-id                        # ❌ CHANGE THIS (use: 1000)

# Required Neo4j (if using original compose - not needed for t3small)
NEO4J_AUTH=neo4j/password                              # ❌ CHANGE THIS

# Required Langfuse (if using original compose - not needed for t3small)
CLICKHOUSE_PASSWORD=super-secret-key-1                 # ❌ CHANGE THIS
MINIO_ROOT_PASSWORD=super-secret-key-2                 # ❌ CHANGE THIS
LANGFUSE_SALT=super-secret-key-3                       # ❌ CHANGE THIS
NEXTAUTH_SECRET=super-secret-key-4                     # ❌ CHANGE THIS
ENCRYPTION_KEY=generate-with-openssl                   # ❌ CHANGE THIS
```

**FOR PRODUCTION with SSL** (optional, can be set later):
```bash
# Configure these for automatic SSL certificates
N8N_HOSTNAME=n8n.yourdomain.com                        # ⚠️ SET YOUR DOMAIN
WEBUI_HOSTNAME=openwebui.yourdomain.com                # ⚠️ SET YOUR DOMAIN
FLOWISE_HOSTNAME=flowise.yourdomain.com                # ⚠️ SET YOUR DOMAIN
SUPABASE_HOSTNAME=supabase.yourdomain.com              # ⚠️ SET YOUR DOMAIN
QDRANT_HOSTNAME=qdrant.yourdomain.com                  # ⚠️ SET YOUR DOMAIN
LETSENCRYPT_EMAIL=admin@yourdomain.com                 # ⚠️ SET YOUR EMAIL
```

---

## 🛠️ **Quick Setup Commands**

### Generate Secure Keys
```bash
# Generate all required secure keys at once
echo "N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)"
echo "N8N_USER_MANAGEMENT_JWT_SECRET=$(openssl rand -hex 32)"
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32 | tr -d '=+/' | cut -c1-25)"
echo "JWT_SECRET=$(openssl rand -hex 32)"
echo "DASHBOARD_PASSWORD=$(openssl rand -base64 16 | tr -d '=+/' | cut -c1-12)"
```

### Update .env File
```bash
# Edit the .env file
nano .env

# Or use your preferred editor
code .env
```

---

## 📋 **Deployment Options**

### Option 1: **Local Testing** (localhost only)
- ✅ Update security keys in `.env`
- ✅ Leave hostnames as localhost
- ✅ Run: `python3 start_t3small.py`
- ✅ Access via http://localhost:5678 (n8n)

### Option 2: **Production with SSL** 
- ✅ Update security keys in `.env`
- ✅ Set your domain names in `.env`
- ✅ Configure DNS A records
- ✅ Run: `python3 start_t3small.py`
- ✅ Access via https://n8n.yourdomain.com

---

## 🔍 **Files That DON'T Need Changes**

These are optimized and ready to use:
- ✅ `docker-compose.t3small.yml` - Optimized for 2GB RAM
- ✅ `Caddyfile.t3small` - SSL/TLS configuration
- ✅ `start_t3small.py` - Sequential startup script
- ✅ `update_n8n.sh` - Auto-update with backup
- ✅ `setup_autoupdate.sh` - Auto-update setup
- ✅ All other configuration files

---

## ⚠️ **Security Warnings**

**NEVER use default values in production:**
- `super-secret-key` 
- `even-more-secret`
- `your-super-secret-and-long-postgres-password`
- `this_password_is_insecure_and_should_be_updated`

**These will make your deployment vulnerable to attacks!**

---

## 🚀 **Ready to Deploy?**

1. ✅ **Updated `.env`** with secure keys
2. ✅ **Configured domains** (for SSL) or using localhost
3. ✅ **DNS records set** (if using domains)
4. ✅ **Run deployment**: `python3 start_t3small.py`

## 🎯 **That's it!** 

Only the `.env` file needs updates. Everything else is optimized and ready for AWS t3.small deployment!