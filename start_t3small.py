#!/usr/bin/env python3
"""
start_t3small.py

Optimized startup script for AWS t3.small (2GB RAM) deployment.
Starts services sequentially to manage memory usage and prevent OOM kills.

Services included:
- Supabase (database backend)
- n8n (workflow automation)
- Ollama (local AI models)
- Open WebUI (AI chat interface)
- Flowise (AI workflow builder)
- Qdrant (vector database)
- Caddy (reverse proxy with SSL)
"""

import os
import subprocess
import shutil
import time
import argparse
import sys

def run_command(cmd, cwd=None):
    """Run a shell command and print it."""
    print("Running:", " ".join(cmd))
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"❌ Command failed: {result.stderr}")
        return False
    return True

def clone_supabase_repo():
    """Clone the Supabase repository using sparse checkout if not already present."""
    if not os.path.exists("supabase"):
        print("📥 Cloning the Supabase repository...")
        if not run_command([
            "git", "clone", "--filter=blob:none", "--no-checkout",
            "https://github.com/supabase/supabase.git"
        ]):
            return False
        
        os.chdir("supabase")
        run_command(["git", "sparse-checkout", "init", "--cone"])
        run_command(["git", "sparse-checkout", "set", "docker"])
        run_command(["git", "checkout", "master"])
        os.chdir("..")
    else:
        print("📂 Supabase repository already exists, updating...")
        os.chdir("supabase")
        run_command(["git", "pull"])
        os.chdir("..")
    return True

def prepare_supabase_env():
    """Copy .env to supabase/docker directory."""
    env_path = os.path.join("supabase", "docker", ".env")
    env_source_path = ".env"
    print("📋 Copying .env to supabase/docker...")
    shutil.copyfile(env_source_path, env_path)

def stop_existing_containers():
    """Stop existing containers for clean startup."""
    print("🛑 Stopping existing containers...")
    # Stop using both compose files to catch any running services
    for compose_file in ["docker-compose.yml", "docker-compose.t3small.yml"]:
        if os.path.exists(compose_file):
            run_command([
                "docker", "compose", "-p", "hpc-n8n-ai",
                "-f", compose_file, "down"
            ])
    
    # Also stop supabase services
    if os.path.exists("supabase/docker/docker-compose.yml"):
        run_command([
            "docker", "compose", "-p", "hpc-n8n-ai",
            "-f", "supabase/docker/docker-compose.yml", "down"
        ])

def start_supabase():
    """Start Supabase services."""
    print("🗃️  Starting Supabase services...")
    return run_command([
        "docker", "compose", "-p", "hpc-n8n-ai",
        "-f", "supabase/docker/docker-compose.yml",
        "up", "-d"
    ])

def wait_for_supabase():
    """Wait for Supabase to be ready."""
    print("⏳ Waiting for Supabase to initialize...")
    max_attempts = 30
    attempt = 0
    
    while attempt < max_attempts:
        try:
            # Check if Supabase API is responding
            result = subprocess.run([
                "curl", "-f", "-s", "http://localhost:8000/health"
            ], capture_output=True, timeout=5)
            
            if result.returncode == 0:
                print("✅ Supabase is ready!")
                return True
                
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass
        
        print(f"   Attempt {attempt + 1}/{max_attempts}...")
        time.sleep(10)
        attempt += 1
    
    print("⚠️  Supabase may not be fully ready, continuing anyway...")
    return False

def start_core_services():
    """Start core services (n8n, Qdrant)."""
    print("🔧 Starting core services (n8n, Qdrant)...")
    return run_command([
        "docker", "compose", "-p", "hpc-n8n-ai",
        "--profile", "cpu",
        "-f", "docker-compose.t3small.yml",
        "up", "-d", "n8n", "qdrant"
    ])

def start_ai_services():
    """Start AI services (Ollama, Open WebUI, Flowise)."""
    print("🤖 Starting AI services...")
    print("   Note: Ollama will download models on first run (may take several minutes)")
    
    # Start Ollama first (it needs time to download models)
    if not run_command([
        "docker", "compose", "-p", "hpc-n8n-ai",
        "--profile", "cpu",
        "-f", "docker-compose.t3small.yml",
        "up", "-d", "ollama-cpu"
    ]):
        return False
    
    # Wait a bit for Ollama to start downloading
    print("⏳ Waiting for Ollama to start model download...")
    time.sleep(30)
    
    # Start other AI services
    return run_command([
        "docker", "compose", "-p", "hpc-n8n-ai",
        "--profile", "cpu",
        "-f", "docker-compose.t3small.yml",
        "up", "-d", "open-webui", "flowise"
    ])

def start_proxy():
    """Start Caddy reverse proxy."""
    print("🌐 Starting Caddy reverse proxy...")
    return run_command([
        "docker", "compose", "-p", "hpc-n8n-ai",
        "--profile", "cpu",
        "-f", "docker-compose.t3small.yml",
        "up", "-d", "caddy"
    ])

def show_status():
    """Show running containers and access information."""
    print("\n" + "="*60)
    print("🎉 HPC n8n AI Stack - Deployment Complete!")
    print("="*60)
    
    # Show running containers
    print("\n📦 Running Containers:")
    subprocess.run([
        "docker", "compose", "-p", "hpc-n8n-ai",
        "-f", "docker-compose.t3small.yml",
        "ps"
    ])
    
    print("\n🌐 Service Access URLs:")
    print("   n8n Workflows:    http://localhost:8001")
    print("   Open WebUI:       http://localhost:8002")
    print("   Flowise:          http://localhost:8003")
    print("   Qdrant:           http://localhost:8004")
    print("   Supabase:         http://localhost:8005")
    print("   Ollama API:       http://localhost:8006")
    
    print("\n📊 Memory Usage:")
    subprocess.run([
        "docker", "stats", "--no-stream", "--format",
        "table {{.Name}}\\t{{.CPUPerc}}\\t{{.MemUsage}}\\t{{.MemPerc}}"
    ])
    
    print("\n📝 Next Steps:")
    print("   1. Access n8n at http://localhost:8001 to create workflows")
    print("   2. Open WebUI at http://localhost:8002 for AI chat")
    print("   3. Check Ollama model download: docker logs ollama")
    print("   4. Monitor resources: docker stats")
    print("\n💡 Tips:")
    print("   - First Ollama model download may take 10-15 minutes")
    print("   - If memory issues occur, restart services individually")
    print("   - Use 'docker compose -p hpc-n8n-ai logs' to check logs")

def main():
    parser = argparse.ArgumentParser(
        description='Start HPC n8n AI Stack optimized for AWS t3.small (2GB RAM)'
    )
    parser.add_argument('--skip-supabase', action='store_true',
                      help='Skip Supabase startup (if already running)')
    parser.add_argument('--skip-wait', action='store_true',
                      help='Skip waiting for services to be ready')
    args = parser.parse_args()

    print("🚀 Starting HPC n8n AI Stack for t3.small...")
    print("💾 Memory optimized for 2GB RAM with sequential startup")
    
    # Check if docker-compose.t3small.yml exists
    if not os.path.exists("docker-compose.t3small.yml"):
        print("❌ docker-compose.t3small.yml not found!")
        print("   Make sure you're in the correct directory")
        return 1
    
    # Check if .env exists
    if not os.path.exists(".env"):
        print("❌ .env file not found!")
        print("   Copy .env.example to .env and configure your settings")
        return 1
    
    # Step 1: Setup Supabase
    if not args.skip_supabase:
        if not clone_supabase_repo():
            print("❌ Failed to setup Supabase repository")
            return 1
        
        prepare_supabase_env()
        
        # Step 2: Clean shutdown
        stop_existing_containers()
        
        # Step 3: Start Supabase
        if not start_supabase():
            print("❌ Failed to start Supabase")
            return 1
        
        # Step 4: Wait for Supabase
        if not args.skip_wait:
            wait_for_supabase()
    
    # Step 5: Start core services
    if not start_core_services():
        print("❌ Failed to start core services")
        return 1
    
    if not args.skip_wait:
        print("⏳ Waiting for core services to stabilize...")
        time.sleep(15)
    
    # Step 6: Start AI services
    if not start_ai_services():
        print("❌ Failed to start AI services")
        return 1
    
    if not args.skip_wait:
        print("⏳ Waiting for AI services to stabilize...")
        time.sleep(20)
    
    # Step 7: Start proxy
    if not start_proxy():
        print("❌ Failed to start proxy")
        return 1
    
    # Step 8: Show status
    if not args.skip_wait:
        time.sleep(5)
    show_status()
    
    return 0

if __name__ == "__main__":
    sys.exit(main())