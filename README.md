# HPC Local AI Stack - AWS t3.small Optimized# Local AI Stack - AWS t3.small Optimized# Self-hosted AI Package



🚀 **Optimized Local AI Stack for AWS t3.small instances with Ubuntu 24.04 LTS**



A streamlined deployment of the most essential AI services, optimized for small cloud instances with automatic n8n updates.🚀 **Optimized Local AI Stack for AWS t3.small instances with Ubuntu 24.04 LTS****Self-hosted AI Package** is an open, docker compose template that



## 🎯 What's Includedquickly bootstraps a fully featured Local AI and Low Code development



✅ **n8n** - Low-code platform with 400+ integrations and AI components (256MB limit)  A streamlined deployment of the most essential AI services, optimized for small cloud instances with automatic n8n updates.environment including Ollama for your local LLMs, Open WebUI for an interface to chat with your N8N agents, and Supabase for your database, vector store, and authentication. 

✅ **Supabase** - Open source database as a service for AI agents  

✅ **Ollama** - Local LLM platform (1.5GB limit, single model)  

✅ **Open WebUI** - ChatGPT-like interface (256MB limit)  

✅ **Flowise** - No/low code AI agent builder (256MB limit)  ## 🎯 What's IncludedThis is Cole's version with a couple of improvements and the addition of Supabase, Open WebUI, Flowise, Neo4j, Langfuse, SearXNG, and Caddy!

✅ **Qdrant** - High performance vector store (256MB limit)  

✅ **Caddy** - Automatic SSL/TLS with Let's Encrypt (64MB limit)  Also, the local RAG AI Agent workflows from the video will be automatically in your 



## 🏗️ Optimizations for t3.small (2GB RAM)✅ **n8n** - Low-code platform with 400+ integrations and AI components (256MB limit)  n8n instance if you use this setup instead of the base one provided by n8n!



- **Memory limits** on all services to prevent OOM✅ **Supabase** - Open source database as a service for AI agents  

- **Removed unnecessary services** (Neo4j, Langfuse, SearXNG, ClickHouse, Minio)

- **Single LLM model** loading with reduced context length✅ **Ollama** - Local LLM platform (1.5GB limit, single model)  **IMPORANT**: Supabase has updated a couple environment variables so you may have to add some new default values in your .env that I have in my .env.example if you have had this project up and running already and are just pulling new changes. Specifically, you need to add "POOLER_DB_POOL_SIZE=5" to your .env. This is required if you have had the package running before June 14th.

- **Sequential startup** to manage memory spikes

- **Automatic n8n updates** with backup and rollback✅ **Open WebUI** - ChatGPT-like interface (256MB limit)  

- **Optimized Caddy** configuration for minimal resource usage

✅ **Flowise** - No/low code AI agent builder (256MB limit)  ## Important Links

## 🚀 Quick Start

✅ **Qdrant** - High performance vector store (256MB limit)  

### 1. Launch AWS EC2 t3.small

- Ubuntu 24.04 LTS✅ **Caddy** - Automatic SSL/TLS with Let's Encrypt (64MB limit)  - [Local AI community](https://thinktank.ottomator.ai/c/local-ai/18) forum over in the oTTomator Think Tank

- Security group: ports 22, 80, 443

- 2GB RAM, 1 vCPU



### 2. Deploy the Stack## 🏗️ Optimizations for t3.small (2GB RAM)- [GitHub Kanban board](https://github.com/users/coleam00/projects/2/views/1) for feature implementation and bug squashing.

```bash

# Clone this repository

git clone https://github.com/highlandpc/hpc-n8n-ai.git

cd hpc-n8n-ai- **Memory limits** on all services to prevent OOM- [Original Local AI Starter Kit](https://github.com/n8n-io/self-hosted-ai-starter-kit) by the n8n team



# Start optimized services- **Removed unnecessary services** (Neo4j, Langfuse, SearXNG, ClickHouse, Minio)

python3 start_t3small.py

- **Single LLM model** loading with reduced context length- Download my N8N + OpenWebUI integration [directly on the Open WebUI site.](https://openwebui.com/f/coleam/n8n_pipe/) (more instructions below)

# Setup auto-updates (optional)

./setup_autoupdate.sh- **Sequential startup** to manage memory spikes

```

- **Automatic n8n updates** with backup and rollback![n8n.io - Screenshot](https://raw.githubusercontent.com/n8n-io/self-hosted-ai-starter-kit/main/assets/n8n-demo.gif)

### 3. Access Services

- **n8n**: http://localhost:5678- **Optimized Caddy** configuration for minimal resource usage

- **Open WebUI**: http://localhost:3000

- **Flowise**: http://localhost:3001Curated by <https://github.com/n8n-io> and <https://github.com/coleam00>, it combines the self-hosted n8n

- **Supabase**: http://localhost:8000

- **Qdrant**: http://localhost:6333## 🚀 Quick Startplatform with a curated list of compatible AI products and components to



## 🔄 Automatic n8n Updatesquickly get started with building self-hosted AI workflows.



Since n8n updates weekly, this stack includes multiple auto-update options:### 1. Launch AWS EC2 t3.small



```bash- Ubuntu 24.04 LTS### What’s included

# Interactive setup

./setup_autoupdate.sh- Security group: ports 22, 80, 443



# Check update status- 2GB RAM, 1 vCPU✅ [**Self-hosted n8n**](https://n8n.io/) - Low-code platform with over 400

./check_autoupdate.sh

integrations and advanced AI components

# Manual update

./update_n8n.sh### 2. Deploy the Stack

```

```bash✅ [**Supabase**](https://supabase.com/) - Open source database as a service -

### Auto-Update Methods:

1. **🐳 Watchtower** - Docker-based (recommended)# Clone this repositorymost widely used database for AI agents

2. **⚙️ Systemd Timer** - System-level scheduling

3. **⏰ Cron Job** - User-level schedulinggit clone https://github.com/yourusername/local-ai-t3small-optimized.git



All methods include automatic backup and rollback on failure.cd local-ai-t3small-optimized✅ [**Ollama**](https://ollama.com/) - Cross-platform LLM platform to install



## 🌐 Production Setup (SSL)and run the latest local LLMs



1. **Configure domains** in `.env`:# Start optimized services

```bash

N8N_HOSTNAME=n8n.yourdomain.compython3 start_t3small.py✅ [**Open WebUI**](https://openwebui.com/) - ChatGPT-like interface to

WEBUI_HOSTNAME=openwebui.yourdomain.com

FLOWISE_HOSTNAME=flowise.yourdomain.comprivately interact with your local models and N8N agents

SUPABASE_HOSTNAME=supabase.yourdomain.com

QDRANT_HOSTNAME=qdrant.yourdomain.com# Setup auto-updates (optional)

LETSENCRYPT_EMAIL=admin@yourdomain.com

```./setup_autoupdate.sh✅ [**Flowise**](https://flowiseai.com/) - No/low code AI agent



2. **Set DNS A records** pointing to your EC2 IP```builder that pairs very well with n8n



3. **Restart services** with Caddy for automatic SSL



## 📊 Resource Usage### 3. Access Services✅ [**Qdrant**](https://qdrant.tech/) - Open source, high performance vector



Optimized for **2GB RAM**:- **n8n**: http://localhost:5678store with an comprehensive API. Even though you can use Supabase for RAG, this was

- Ollama: 1.5GB (single model)

- n8n: 256MB- **Open WebUI**: http://localhost:3000kept unlike Postgres since it's faster than Supabase so sometimes is the better option.

- Open WebUI: 256MB

- Flowise: 256MB- **Flowise**: http://localhost:3001

- Qdrant: 256MB

- Caddy: 64MB- **Supabase**: http://localhost:8000✅ [**Neo4j**](https://neo4j.com/) - Knowledge graph engine that powers tools like GraphRAG, LightRAG, and Graphiti 

- Supabase: ~300MB

- System buffer: ~200MB- **Qdrant**: http://localhost:6333



## 🛠️ Management Commands✅ [**SearXNG**](https://searxng.org/) - Open source, free internet metasearch engine which aggregates 



```bash## 🔄 Automatic n8n Updatesresults from up to 229 search services. Users are neither tracked nor profiled, hence the fit with the local AI package.

# Start services

python3 start_t3small.py



# Check statusSince n8n updates weekly, this stack includes multiple auto-update options:✅ [**Caddy**](https://caddyserver.com/) - Managed HTTPS/TLS for custom domains

docker compose -f docker-compose.t3small.yml ps



# View logs

docker compose -f docker-compose.t3small.yml logs -f```bash✅ [**Langfuse**](https://langfuse.com/) - Open source LLM engineering platform for agent observability



# Stop services# Interactive setup

docker compose -f docker-compose.t3small.yml down

./setup_autoupdate.sh## Prerequisites

# Update n8n manually

./update_n8n.sh



# Check auto-update status# Check update statusBefore you begin, make sure you have the following software installed:

./check_autoupdate.sh

```./check_autoupdate.sh



## 📁 File Structure- [Python](https://www.python.org/downloads/) - Required to run the setup script



```# Manual update- [Git/GitHub Desktop](https://desktop.github.com/) - For easy repository management

├── docker-compose.t3small.yml    # Optimized compose file

├── Caddyfile.t3small             # SSL/TLS configuration./update_n8n.sh- [Docker/Docker Desktop](https://www.docker.com/products/docker-desktop/) - Required to run all services

├── start_t3small.py              # Optimized startup script

├── update_n8n.sh                 # n8n update with backup```

├── setup_autoupdate.sh           # Auto-update setup

├── check_autoupdate.sh           # Update status checker## Installation

├── n8n-autoupdate.service        # Systemd service

├── n8n-autoupdate.timer          # Systemd timer### Auto-Update Methods:

└── README-t3small.md             # Detailed guide

```1. **🐳 Watchtower** - Docker-based (recommended)Clone the repository and navigate to the project directory:



## 🔧 Differences from Original2. **⚙️ Systemd Timer** - System-level scheduling```bash



This is a **streamlined version** of [local-ai-packaged](https://github.com/coleam00/local-ai-packaged) with:3. **⏰ Cron Job** - User-level schedulinggit clone -b stable https://github.com/coleam00/local-ai-packaged.git



- **Removed services**: Neo4j, Langfuse, SearXNG, ClickHouse, Minio, Rediscd local-ai-packaged

- **Added optimizations**: Memory limits, resource constraints

- **Added auto-updates**: Multiple methods for n8n updatesAll methods include automatic backup and rollback on failure.```

- **Simplified config**: Focused on essential AI workflow tools



## 📚 Documentation

## 🌐 Production Setup (SSL)Before running the services, you need to set up your environment variables for Supabase following their [self-hosting guide](https://supabase.com/docs/guides/self-hosting/docker#securing-your-services).

- [Detailed Setup Guide](README-t3small.md)

- [GitHub Setup Guide](GITHUB-SETUP.md)

- [Original Project](https://github.com/coleam00/local-ai-packaged)

- [n8n Documentation](https://docs.n8n.io/)1. **Configure domains** in `.env`:1. Make a copy of `.env.example` and rename it to `.env` in the root directory of the project

- [Supabase Self-hosting](https://supabase.com/docs/guides/self-hosting)

```bash2. Set the following required environment variables:

## 🆘 Support

N8N_HOSTNAME=n8n.yourdomain.com   ```bash

For issues:

1. Check the [detailed guide](README-t3small.md)WEBUI_HOSTNAME=openwebui.yourdomain.com   ############

2. Review logs: `docker compose logs -f`

3. Check resource usage: `docker stats`FLOWISE_HOSTNAME=flowise.yourdomain.com   # N8N Configuration

4. Verify DNS and SSL configuration

SUPABASE_HOSTNAME=supabase.yourdomain.com   ############

## 📄 License

QDRANT_HOSTNAME=qdrant.yourdomain.com   N8N_ENCRYPTION_KEY=

Based on [local-ai-packaged](https://github.com/coleam00/local-ai-packaged) - Apache License 2.0

LETSENCRYPT_EMAIL=admin@yourdomain.com   N8N_USER_MANAGEMENT_JWT_SECRET=

---

```

**⚡ Perfect for small cloud deployments needing essential AI services with automatic updates!**

   ############

Maintained by [Highland PC](https://github.com/highlandpc)
2. **Set DNS A records** pointing to your EC2 IP   # Supabase Secrets

   ############

3. **Restart services** with Caddy for automatic SSL   POSTGRES_PASSWORD=

   JWT_SECRET=

## 📊 Resource Usage   ANON_KEY=

   SERVICE_ROLE_KEY=

Optimized for **2GB RAM**:   DASHBOARD_USERNAME=

- Ollama: 1.5GB (single model)   DASHBOARD_PASSWORD=

- n8n: 256MB   POOLER_TENANT_ID=

- Open WebUI: 256MB

- Flowise: 256MB   ############

- Qdrant: 256MB   # Neo4j Secrets

- Caddy: 64MB   ############   

- Supabase: ~300MB   NEO4J_AUTH=

- System buffer: ~200MB

   ############

## 🛠️ Management Commands   # Langfuse credentials

   ############

```bash

# Start services   CLICKHOUSE_PASSWORD=

python3 start_t3small.py   MINIO_ROOT_PASSWORD=

   LANGFUSE_SALT=

# Check status   NEXTAUTH_SECRET=

docker compose -f docker-compose.t3small.yml ps   ENCRYPTION_KEY=  

   ```

# View logs

docker compose -f docker-compose.t3small.yml logs -f> [!IMPORTANT]

> Make sure to generate secure random values for all secrets. Never use the example values in production.

# Stop services

docker compose -f docker-compose.t3small.yml down3. Set the following environment variables if deploying to production, otherwise leave commented:

   ```bash

# Update n8n manually   ############

./update_n8n.sh   # Caddy Config

   ############

# Check auto-update status

./check_autoupdate.sh   N8N_HOSTNAME=n8n.yourdomain.com

```   WEBUI_HOSTNAME=:openwebui.yourdomain.com

   FLOWISE_HOSTNAME=:flowise.yourdomain.com

## 📁 File Structure   SUPABASE_HOSTNAME=:supabase.yourdomain.com

   OLLAMA_HOSTNAME=:ollama.yourdomain.com

```   SEARXNG_HOSTNAME=searxng.yourdomain.com

├── docker-compose.t3small.yml    # Optimized compose file   NEO4J_HOSTNAME=neo4j.yourdomain.com

├── Caddyfile.t3small             # SSL/TLS configuration   LETSENCRYPT_EMAIL=your-email-address

├── start_t3small.py              # Optimized startup script   ```   

├── update_n8n.sh                 # n8n update with backup

├── setup_autoupdate.sh           # Auto-update setup---

├── check_autoupdate.sh           # Update status checker

├── n8n-autoupdate.service        # Systemd serviceThe project includes a `start_services.py` script that handles starting both the Supabase and local AI services. The script accepts a `--profile` flag to specify which GPU configuration to use.

├── n8n-autoupdate.timer          # Systemd timer

└── README-t3small.md             # Detailed guide### For Nvidia GPU users

```

```bash

## 🔧 Differences from Originalpython start_services.py --profile gpu-nvidia

```

This is a **streamlined version** of [local-ai-packaged](https://github.com/coleam00/local-ai-packaged) with:

> [!NOTE]

- **Removed services**: Neo4j, Langfuse, SearXNG, ClickHouse, Minio, Redis> If you have not used your Nvidia GPU with Docker before, please follow the

- **Added optimizations**: Memory limits, resource constraints> [Ollama Docker instructions](https://github.com/ollama/ollama/blob/main/docs/docker.md).

- **Added auto-updates**: Multiple methods for n8n updates

- **Simplified config**: Focused on essential AI workflow tools### For AMD GPU users on Linux



## 📚 Documentation```bash

python start_services.py --profile gpu-amd

- [Detailed Setup Guide](README-t3small.md)```

- [Original Project](https://github.com/coleam00/local-ai-packaged)

- [n8n Documentation](https://docs.n8n.io/)### For Mac / Apple Silicon users

- [Supabase Self-hosting](https://supabase.com/docs/guides/self-hosting)

If you're using a Mac with an M1 or newer processor, you can't expose your GPU to the Docker instance, unfortunately. There are two options in this case:

## 🆘 Support

1. Run the starter kit fully on CPU:

For issues:   ```bash

1. Check the [detailed guide](README-t3small.md)   python start_services.py --profile cpu

2. Review logs: `docker compose logs -f`   ```

3. Check resource usage: `docker stats`

4. Verify DNS and SSL configuration2. Run Ollama on your Mac for faster inference, and connect to that from the n8n instance:

   ```bash

## 📄 License   python start_services.py --profile none

   ```

Based on [local-ai-packaged](https://github.com/coleam00/local-ai-packaged) - Apache License 2.0

   If you want to run Ollama on your mac, check the [Ollama homepage](https://ollama.com/) for installation instructions.

---

#### For Mac users running OLLAMA locally

**⚡ Perfect for small cloud deployments needing essential AI services with automatic updates!**
If you're running OLLAMA locally on your Mac (not in Docker), you need to modify the OLLAMA_HOST environment variable in the n8n service configuration. Update the x-n8n section in your Docker Compose file as follows:

```yaml
x-n8n: &service-n8n
  # ... other configurations ...
  environment:
    # ... other environment variables ...
    - OLLAMA_HOST=host.docker.internal:11434
```

Additionally, after you see "Editor is now accessible via: http://localhost:5678/":

1. Head to http://localhost:5678/home/credentials
2. Click on "Local Ollama service"
3. Change the base URL to "http://host.docker.internal:11434/"

### For everyone else

```bash
python start_services.py --profile cpu
```

### The environment argument
The **start-services.py** script offers the possibility to pass one of two options for the environment argument, **private** (default environment) and **public**:
- **private:** you are deploying the stack in a safe environment, hence a lot of ports can be made accessible without having to worry about security
- **public:** the stack is deployed in a public environment, which means the attack surface should be made as small as possible. All ports except for 80 and 443 are closed

The stack initialized with
```bash
   python start_services.py --profile gpu-nvidia --environment private
   ```
equals the one initialized with
```bash
   python start_services.py --profile gpu-nvidia
   ```

## Deploying to the Cloud

### Prerequisites for the below steps

- Linux machine (preferably Unbuntu) with Nano, Git, and Docker installed

### Extra steps

Before running the above commands to pull the repo and install everything:

1. Run the commands as root to open up the necessary ports:
   - ufw enable
   - ufw allow 80 && ufw allow 443
   - ufw reload
   ---
   **WARNING**

   ufw does not shield ports published by docker, because the iptables rules configured by docker are analyzed before those configured by ufw. There is a solution to change this behavior, but that is out of scope for this project. Just make sure that all traffic runs through the caddy service via port 443. Port 80 should only be used to redirect to port 443.

   ---
2. Run the **start-services.py** script with the environment argument **public** to indicate you are going to run the package in a public environment. The script will make sure that all ports, except for 80 and 443, are closed down, e.g.

```bash
   python3 start_services.py --profile gpu-nvidia --environment public
   ```

3. Set up A records for your DNS provider to point your subdomains you'll set up in the .env file for Caddy
to the IP address of your cloud instance.

   For example, A record to point n8n to [cloud instance IP] for n8n.yourdomain.com


**NOTE**: If you are using a cloud machine without the "docker compose" command available by default, such as a Ubuntu GPU instance on DigitalOcean, run these commands before running start_services.py:

- DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\\" -f4)
- sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
- sudo chmod +x /usr/local/bin/docker-compose
- sudo mkdir -p /usr/local/lib/docker/cli-plugins
- sudo ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

## ⚡️ Quick start and usage

The main component of the self-hosted AI starter kit is a docker compose file
pre-configured with network and disk so there isn’t much else you need to
install. After completing the installation steps above, follow the steps below
to get started.

1. Open <http://localhost:5678/> in your browser to set up n8n. You’ll only
   have to do this once. You are NOT creating an account with n8n in the setup here,
   it is only a local account for your instance!
2. Open the included workflow:
   <http://localhost:5678/workflow/vTN9y2dLXqTiDfPT>
3. Create credentials for every service:
   
   Ollama URL: http://ollama:11434

   Postgres (through Supabase): use DB, username, and password from .env. IMPORTANT: Host is 'db'
   Since that is the name of the service running Supabase

   Qdrant URL: http://qdrant:6333 (API key can be whatever since this is running locally)

   Google Drive: Follow [this guide from n8n](https://docs.n8n.io/integrations/builtin/credentials/google/).
   Don't use localhost for the redirect URI, just use another domain you have, it will still work!
   Alternatively, you can set up [local file triggers](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.localfiletrigger/).
4. Select **Test workflow** to start running the workflow.
5. If this is the first time you’re running the workflow, you may need to wait
   until Ollama finishes downloading Llama3.1. You can inspect the docker
   console logs to check on the progress.
6. Make sure to toggle the workflow as active and copy the "Production" webhook URL!
7. Open <http://localhost:3000/> in your browser to set up Open WebUI.
You’ll only have to do this once. You are NOT creating an account with Open WebUI in the 
setup here, it is only a local account for your instance!
8. Go to Workspace -> Functions -> Add Function -> Give name + description then paste in
the code from `n8n_pipe.py`

   The function is also [published here on Open WebUI's site](https://openwebui.com/f/coleam/n8n_pipe/).

9. Click on the gear icon and set the n8n_url to the production URL for the webhook
you copied in a previous step.
10. Toggle the function on and now it will be available in your model dropdown in the top left! 

To open n8n at any time, visit <http://localhost:5678/> in your browser.
To open Open WebUI at any time, visit <http://localhost:3000/>.

With your n8n instance, you’ll have access to over 400 integrations and a
suite of basic and advanced AI nodes such as
[AI Agent](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.agent/),
[Text classifier](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.text-classifier/),
and [Information Extractor](https://docs.n8n.io/integrations/builtin/cluster-nodes/root-nodes/n8n-nodes-langchain.information-extractor/)
nodes. To keep everything local, just remember to use the Ollama node for your
language model and Qdrant as your vector store.

> [!NOTE]
> This starter kit is designed to help you get started with self-hosted AI
> workflows. While it’s not fully optimized for production environments, it
> combines robust components that work well together for proof-of-concept
> projects. You can customize it to meet your specific needs

## Upgrading

To update all containers to their latest versions (n8n, Open WebUI, etc.), run these commands:

```bash
# Stop all services
docker compose -p localai -f docker-compose.yml --profile <your-profile> down

# Pull latest versions of all containers
docker compose -p localai -f docker-compose.yml --profile <your-profile> pull

# Start services again with your desired profile
python start_services.py --profile <your-profile>
```

Replace `<your-profile>` with one of: `cpu`, `gpu-nvidia`, `gpu-amd`, or `none`.

Note: The `start_services.py` script itself does not update containers - it only restarts them or pulls them if you are downloading these containers for the first time. To get the latest versions, you must explicitly run the commands above.

## Troubleshooting

Here are solutions to common issues you might encounter:

### Supabase Issues

- **Supabase Pooler Restarting**: If the supabase-pooler container keeps restarting itself, follow the instructions in [this GitHub issue](https://github.com/supabase/supabase/issues/30210#issuecomment-2456955578).

- **Supabase Analytics Startup Failure**: If the supabase-analytics container fails to start after changing your Postgres password, delete the folder `supabase/docker/volumes/db/data`.

- **If using Docker Desktop**: Go into the Docker settings and make sure "Expose daemon on tcp://localhost:2375 without TLS" is turned on

- **Supabase Service Unavailable** - Make sure you don't have an "@" character in your Postgres password! If the connection to the kong container is working (the container logs say it is receiving requests from n8n) but n8n says it cannot connect, this is generally the problem from what the community has shared. Other characters might not be allowed too, the @ symbol is just the one I know for sure!

- **Files not Found in Supabase Folder** - If you get any errors around files missing in the supabase/ folder like .env, docker/docker-compose.yml, etc. this most likely means you had a "bad" pull of the Supabase GitHub repository when you ran the start_services.py script. Delete the supabase/ folder within the Local AI Package folder entirely and try again.

### GPU Support Issues

- **Windows GPU Support**: If you're having trouble running Ollama with GPU support on Windows with Docker Desktop:
  1. Open Docker Desktop settings
  2. Enable WSL 2 backend
  3. See the [Docker GPU documentation](https://docs.docker.com/desktop/features/gpu/) for more details

- **Linux GPU Support**: If you're having trouble running Ollama with GPU support on Linux, follow the [Ollama Docker instructions](https://github.com/ollama/ollama/blob/main/docs/docker.md).

## 👓 Recommended reading

n8n is full of useful content for getting started quickly with its AI concepts
and nodes. If you run into an issue, go to [support](#support).

- [AI agents for developers: from theory to practice with n8n](https://blog.n8n.io/ai-agents/)
- [Tutorial: Build an AI workflow in n8n](https://docs.n8n.io/advanced-ai/intro-tutorial/)
- [Langchain Concepts in n8n](https://docs.n8n.io/advanced-ai/langchain/langchain-n8n/)
- [Demonstration of key differences between agents and chains](https://docs.n8n.io/advanced-ai/examples/agent-chain-comparison/)
- [What are vector databases?](https://docs.n8n.io/advanced-ai/examples/understand-vector-databases/)

## 🎥 Video walkthrough

- [Cole's Guide to the Local AI Starter Kit](https://youtu.be/pOsO40HSbOo)

## 🛍️ More AI templates

For more AI workflow ideas, visit the [**official n8n AI template
gallery**](https://n8n.io/workflows/?categories=AI). From each workflow,
select the **Use workflow** button to automatically import the workflow into
your local n8n instance.

### Learn AI key concepts

- [AI Agent Chat](https://n8n.io/workflows/1954-ai-agent-chat/)
- [AI chat with any data source (using the n8n workflow too)](https://n8n.io/workflows/2026-ai-chat-with-any-data-source-using-the-n8n-workflow-tool/)
- [Chat with OpenAI Assistant (by adding a memory)](https://n8n.io/workflows/2098-chat-with-openai-assistant-by-adding-a-memory/)
- [Use an open-source LLM (via HuggingFace)](https://n8n.io/workflows/1980-use-an-open-source-llm-via-huggingface/)
- [Chat with PDF docs using AI (quoting sources)](https://n8n.io/workflows/2165-chat-with-pdf-docs-using-ai-quoting-sources/)
- [AI agent that can scrape webpages](https://n8n.io/workflows/2006-ai-agent-that-can-scrape-webpages/)

### Local AI templates

- [Tax Code Assistant](https://n8n.io/workflows/2341-build-a-tax-code-assistant-with-qdrant-mistralai-and-openai/)
- [Breakdown Documents into Study Notes with MistralAI and Qdrant](https://n8n.io/workflows/2339-breakdown-documents-into-study-notes-using-templating-mistralai-and-qdrant/)
- [Financial Documents Assistant using Qdrant and](https://n8n.io/workflows/2335-build-a-financial-documents-assistant-using-qdrant-and-mistralai/) [ Mistral.ai](http://mistral.ai/)
- [Recipe Recommendations with Qdrant and Mistral](https://n8n.io/workflows/2333-recipe-recommendations-with-qdrant-and-mistral/)

## Tips & tricks

### Accessing local files

The self-hosted AI starter kit will create a shared folder (by default,
located in the same directory) which is mounted to the n8n container and
allows n8n to access files on disk. This folder within the n8n container is
located at `/data/shared` -- this is the path you’ll need to use in nodes that
interact with the local filesystem.

**Nodes that interact with the local filesystem**

- [Read/Write Files from Disk](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.filesreadwrite/)
- [Local File Trigger](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.localfiletrigger/)
- [Execute Command](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.executecommand/)

## 📜 License

This project (originally created by the n8n team, link at the top of the README) is licensed under the Apache License 2.0 - see the
[LICENSE](LICENSE) file for details.
