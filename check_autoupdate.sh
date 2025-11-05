#!/bin/bash

# Check n8n Auto-Update Status
# Shows current configuration and last update info

echo "🔍 n8n Auto-Update Status Check"
echo "==============================="
echo ""

# Check if n8n is running
if docker compose -f docker-compose.t3small.yml ps n8n | grep -q "Up"; then
    echo "✅ n8n Status: Running"
    
    # Get n8n version
    N8N_VERSION=$(docker compose -f docker-compose.t3small.yml exec -T n8n n8n --version 2>/dev/null | head -1 || echo "Unknown")
    echo "📋 n8n Version: $N8N_VERSION"
    
    # Get container image info
    IMAGE_INFO=$(docker inspect n8n --format='{{.Config.Image}} ({{.Created}})' 2>/dev/null || echo "Unknown")
    echo "🐳 Docker Image: $IMAGE_INFO"
else
    echo "❌ n8n Status: Not running"
fi

echo ""
echo "🔄 Auto-Update Configurations"
echo "============================="

# Check Watchtower
if docker compose -f docker-compose.t3small.yml ps watchtower 2>/dev/null | grep -q "Up"; then
    echo "✅ Watchtower: Running (Docker auto-updates enabled)"
    echo "   📅 Schedule: Sundays at 2 AM"
    echo "   🎯 Monitoring: n8n container only"
else
    echo "❌ Watchtower: Not running"
    echo "   💡 Enable with: docker compose -f docker-compose.t3small.yml --profile watchtower up -d watchtower"
fi

# Check systemd timer (if available)
if systemctl list-timers n8n-autoupdate.timer 2>/dev/null | grep -q "n8n-autoupdate"; then
    echo "✅ Systemd Timer: Enabled"
    echo "   📅 Next run: $(systemctl list-timers n8n-autoupdate.timer --no-pager | grep n8n-autoupdate | awk '{print $1, $2}')"
else
    echo "❌ Systemd Timer: Not configured"
    echo "   💡 Setup with: sudo ./setup_autoupdate.sh"
fi

# Check cron jobs
CRON_JOBS=$(crontab -l 2>/dev/null | grep -c "update_n8n" || echo "0")
if [ "$CRON_JOBS" -gt 0 ]; then
    echo "✅ Cron Jobs: $CRON_JOBS configured"
    echo "   📋 Jobs:"
    crontab -l 2>/dev/null | grep "update_n8n" | sed 's/^/   /'
else
    echo "❌ Cron Jobs: None configured"
fi

echo ""
echo "📊 Update History"
echo "================"

# Check update log
if [ -f "./n8n/update.log" ]; then
    echo "📄 Last 5 update log entries:"
    tail -n 5 ./n8n/update.log | sed 's/^/   /'
    echo ""
    echo "📁 Full log: ./n8n/update.log"
else
    echo "❌ No update log found"
fi

# Check backups
BACKUP_COUNT=$(find ./n8n/backups -maxdepth 1 -type d -name "20*" 2>/dev/null | wc -l || echo "0")
echo "📦 Available backups: $BACKUP_COUNT"

if [ "$BACKUP_COUNT" -gt 0 ]; then
    echo "   📁 Latest backups:"
    find ./n8n/backups -maxdepth 1 -type d -name "20*" 2>/dev/null | sort -r | head -3 | sed 's/^/   /'
fi

echo ""
echo "🛠️  Quick Commands"
echo "=================="
echo "• Manual update: ./update_n8n.sh"
echo "• Setup auto-updates: ./setup_autoupdate.sh"
echo "• View update logs: tail -f ./n8n/update.log"
echo "• Check Docker images: docker images | grep n8n"
echo "• Enable Watchtower: docker compose -f docker-compose.t3small.yml --profile watchtower up -d watchtower"

echo ""
echo "✅ Status check completed!"