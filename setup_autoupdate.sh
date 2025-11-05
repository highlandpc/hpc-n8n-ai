#!/bin/bash

# Setup n8n Auto-Updates for AWS t3.small
# Configures multiple auto-update methods

set -e

echo "🔄 Setting up n8n Auto-Updates for AWS t3.small"
echo "=============================================="

# Check if running as root for systemd setup
if [[ $EUID -eq 0 ]]; then
    SETUP_SYSTEMD=true
    USER_HOME="/home/ubuntu"
else
    SETUP_SYSTEMD=false
    USER_HOME="$HOME"
    echo "ℹ️  Not running as root - systemd setup will be skipped"
fi

# Create backup directories
echo "📁 Creating backup directories..."
mkdir -p ./n8n/backups
mkdir -p ./n8n/backup/workflows
mkdir -p ./n8n/backup/credentials

# Make update script executable
chmod +x update_n8n.sh

echo "✅ Basic setup completed"

# Setup systemd service (if root)
if [ "$SETUP_SYSTEMD" = true ]; then
    echo "⚙️  Setting up systemd auto-update service..."
    
    # Update service file with correct path
    sed "s|/home/ubuntu|$USER_HOME|g" n8n-autoupdate.service > /etc/systemd/system/n8n-autoupdate.service
    cp n8n-autoupdate.timer /etc/systemd/system/
    
    # Reload systemd and enable timer
    systemctl daemon-reload
    systemctl enable n8n-autoupdate.timer
    systemctl start n8n-autoupdate.timer
    
    echo "✅ Systemd auto-update timer enabled (weekly on Sundays at 2 AM)"
    
    # Show timer status
    systemctl list-timers n8n-autoupdate.timer
else
    echo "⚠️  To enable systemd auto-updates, run this script as root:"
    echo "   sudo ./setup_autoupdate.sh"
fi

# Setup Watchtower option
echo ""
echo "🐳 Watchtower Auto-Update Setup"
echo "==============================="
echo ""
echo "Option 1: Enable Watchtower (Docker-based auto-updates)"
echo "   • Monitors n8n container for updates"
echo "   • Updates every Sunday at 2 AM"
echo "   • Automatic cleanup of old images"
echo ""
read -p "Enable Watchtower auto-updates? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "✅ Starting Watchtower for n8n auto-updates..."
    docker compose -f docker-compose.t3small.yml --profile watchtower up -d watchtower
    echo "✅ Watchtower enabled"
else
    echo "ℹ️  Watchtower not enabled. You can enable it later with:"
    echo "   docker compose -f docker-compose.t3small.yml --profile watchtower up -d watchtower"
fi

# Setup cron job option (for non-root users)
if [ "$SETUP_SYSTEMD" = false ]; then
    echo ""
    echo "⏰ Cron Auto-Update Setup"
    echo "========================="
    echo ""
    echo "Option 2: Setup cron job for auto-updates"
    echo "   • Weekly updates on Sundays at 2 AM"
    echo "   • Runs as current user"
    echo ""
    read -p "Setup cron job for auto-updates? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Add cron job
        CRON_JOB="0 2 * * 0 cd $(pwd) && ./update_n8n.sh >> ./n8n/update.log 2>&1"
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "✅ Cron job added for weekly n8n updates"
        echo "📋 Current cron jobs:"
        crontab -l | grep update_n8n || echo "   (none found)"
    fi
fi

# Show available update methods
echo ""
echo "🎯 Available Auto-Update Methods"
echo "================================"
echo ""
echo "1. 🤖 Watchtower (Docker-based):"
echo "   • Automatic Docker container updates"
echo "   • Monitors n8n image for changes"
echo "   • Updates: Sundays at 2 AM"
echo "   • Enable: docker compose --profile watchtower up -d watchtower"
echo ""

if [ "$SETUP_SYSTEMD" = true ]; then
    echo "2. ⚙️  Systemd Timer (System service):"
    echo "   • System-level scheduled updates"
    echo "   • Includes backup and rollback"
    echo "   • Updates: Sundays at 2 AM"
    echo "   • Status: systemctl status n8n-autoupdate.timer"
    echo ""
fi

echo "3. ⏰ Cron Job (User-level):"
echo "   • User-level scheduled updates"
echo "   • Includes backup and rollback"
echo "   • Updates: Sundays at 2 AM"
echo "   • Manual setup available"
echo ""

echo "4. 🔧 Manual Updates:"
echo "   • Run: ./update_n8n.sh"
echo "   • Full control over timing"
echo "   • Includes backup and rollback"
echo ""

# Show management commands
echo "🛠️  Management Commands"
echo "======================"
echo ""
echo "• Manual update: ./update_n8n.sh"
echo "• Check logs: tail -f ./n8n/update.log"
echo "• View backups: ls -la ./n8n/backups/"
echo "• Stop Watchtower: docker compose stop watchtower"

if [ "$SETUP_SYSTEMD" = true ]; then
    echo "• Timer status: systemctl status n8n-autoupdate.timer"
    echo "• View timer logs: journalctl -u n8n-autoupdate.service"
fi

echo "• Cron jobs: crontab -l | grep n8n"
echo ""

echo "✅ n8n Auto-Update setup completed!"
echo ""
echo "💡 Recommendation: Use either Watchtower OR systemd timer, not both"
echo "🔒 All methods include automatic backup before updates"