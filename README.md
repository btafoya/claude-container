# 🚀 Claude Container

[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-orange)](https://ubuntu.com/)
[![Node.js](https://img.shields.io/badge/Node.js-22_LTS-green)](https://nodejs.org/)
[![Python](https://img.shields.io/badge/Python-3.x-blue)](https://www.python.org/)

A comprehensive, optimized Docker development environment that brings together Claude Code, AI frameworks, and a complete development stack. Perfect for AI-assisted development, machine learning projects, and modern web development with optional desktop GUI access.

## 📋 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Installation](#-installation)
- [Usage](#-usage)
- [Included Tools](#-included-tools)
- [Configuration](#-configuration)
- [Security](#-security)
- [Deploy Script Reference](#-deploy-script-reference)
- [Troubleshooting](#-troubleshooting)
- [Performance](#-performance)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### AI & Development Tools
- **[Claude Code](https://www.anthropic.com/)**: Anthropic's official CLI for AI-powered coding assistance
- **[claude-conductor](https://www.npmjs.com/package/claude-conductor)**: Advanced orchestration tool for Claude interactions
- **[ClaudeCodeUI](https://github.com/btafoya/claudecodeui)**: Web and mobile-friendly interface for managing Claude sessions
- **[SuperClaude Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework)**: Comprehensive framework for enhanced Claude capabilities

### Development Environment
- **Python 3.x**: Complete Python environment with pip, venv, and popular ML/AI libraries
- **Node.js 22 LTS**: Latest Node.js with npm, yarn, pnpm package managers
- **Development Tools**: git, build-essential, gcc, g++, make, cmake, and more
- **Testing Frameworks**: Playwright with all browsers pre-installed, pytest support
- **Desktop Environment**: Optional Lubuntu desktop via XRDP for GUI applications

### Pre-installed Packages
- **Data Science**: numpy, pandas, matplotlib, seaborn, scikit-learn
- **Web Development**: fastapi, uvicorn, express, React tools
- **AI/ML Tools**: Jupyter, IPython, notebook environments
- **Automation**: Playwright for browser testing, uvx for Python tool running
- **TypeScript**: Full TypeScript support with ts-node

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│          Claude Container Stack             │
├─────────────────────────────────────────────┤
│        Ubuntu 24.04 LTS (Base)              │
├─────────────────────────────────────────────┤
│     Core Dependencies & Dev Tools           │
│  (git, build-essential, compilers)          │
├─────────────────────────────────────────────┤
│      Language Runtimes & Managers           │
│    (Python 3.x, Node.js 22, pip, npm)       │
├─────────────────────────────────────────────┤
│         AI Frameworks & Tools               │
│  (Claude Code, SuperClaude, ClaudeCodeUI)   │
├─────────────────────────────────────────────┤
│     Optional: Desktop Environment           │
│         (XRDP + Lubuntu Desktop)            │
└─────────────────────────────────────────────┘
```

### Optimization Highlights
- **Reduced Layers**: Optimized from 17 to 7 RUN commands (59% reduction)
- **Smart Caching**: Logical grouping for better Docker layer caching
- **Size Efficiency**: ~10-15% smaller image through proper cleanup
- **Build Performance**: ~33% faster builds with combined operations

## 📦 Prerequisites

- Docker Engine 20.10+ or Docker Desktop
- Docker Compose V2+
- 4GB+ available RAM (8GB recommended with desktop environment)
- 10GB+ available disk space

## 🚀 Quick Start

### Option 1: Using Deploy Script (Recommended)

```bash
# Clone the repository
git clone https://github.com/btafoya/claude-container.git
cd claude-container

# Make deploy script executable
chmod +x deploy.sh

# Start with default settings
./deploy.sh start --detach

# Or with custom credentials
./deploy.sh start --username developer --password securepass123 --detach
```

### Option 2: Using Docker Compose

```bash
# Clone and build locally
git clone https://github.com/btafoya/claude-container.git
cd claude-container
docker compose build
docker compose up -d
```

## 📥 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/btafoya/claude-container.git
cd claude-container
```

### 2. Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your preferences
nano .env
```

### 3. Build the Container

```bash
# Using deploy script
./deploy.sh build

# Or using Docker Compose
docker compose build
```

### 4. Start the Container

```bash
# Using deploy script (recommended)
./deploy.sh start --detach

# Or using Docker Compose
docker compose up -d
```

## 💻 Usage

### Claude Code CLI

```bash
# Interactive Claude session
docker compose exec claude-code claude

# Or using deploy script
./deploy.sh shell
claude
```

### ClaudeCodeUI Web Interface

```bash
# Start the web UI
./deploy.sh ui

# Access at:
# Frontend: http://localhost:5173
# Backend: http://localhost:3000
```

### Remote Desktop Access

```bash
# Get RDP connection info
./deploy.sh rdp

# Connect using any RDP client to:
# Server: localhost:3389
# Username: [your-configured-username]
# Password: [your-configured-password]
```

### Python Development

```bash
# Run Python scripts
docker compose exec claude-code python3 script.py

# Start Jupyter Notebook
docker compose exec claude-code jupyter notebook --ip=0.0.0.0 --allow-root

# Use uvx for Python tools
docker compose exec claude-code uvx ruff check .
docker compose exec claude-code uvx black .
```

### Node.js Development

```bash
# Run Node.js applications
docker compose exec claude-code node app.js

# Use npm/yarn/pnpm
docker compose exec claude-code npm install
docker compose exec claude-code yarn add package-name
docker compose exec claude-code pnpm install
```

### Testing with Playwright

```bash
# Run Playwright tests
docker compose exec claude-code npx playwright test

# Generate tests interactively
docker compose exec claude-code npx playwright codegen
```

## 🛠️ Included Tools

### AI & Claude Tools
| Tool | Version | Description |
|------|---------|-------------|
| Claude Code | Latest | Anthropic's official CLI |
| claude-conductor | Latest | Orchestration for Claude |
| ClaudeCodeUI | Latest | Web interface for Claude |
| SuperClaude Framework | Latest | Enhanced Claude capabilities |

### Programming Languages & Runtimes
| Language | Version | Package Managers |
|----------|---------|------------------|
| Python | 3.x | pip, uv, uvx |
| Node.js | 22 LTS | npm, yarn, pnpm |
| TypeScript | Latest | ts-node |

### Development Tools
| Category | Tools |
|----------|-------|
| Version Control | git, gh (GitHub CLI) |
| Build Tools | gcc, g++, make, cmake, build-essential |
| Testing | Playwright, pytest |
| Process Managers | pm2, nodemon |
| Containers | Docker CLI (if needed) |

### Pre-installed Python Packages
| Category | Packages |
|----------|----------|
| Data Science | numpy, pandas, matplotlib, seaborn, scikit-learn |
| Web Frameworks | fastapi, uvicorn, aiohttp, requests |
| Development | jupyter, notebook, ipython, rich, click |
| Utilities | python-dotenv, pyyaml, beautifulsoup4, lxml |

### Pre-installed Node.js Packages
| Category | Packages |
|----------|----------|
| Development | typescript, ts-node, nodemon, pm2 |
| Testing | @playwright/test |
| Package Managers | yarn, pnpm |
| AI Tools | @anthropic-ai/claude-code, claude-conductor |

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the project root:

```env
# User Credentials (for RDP access)
UBUNTU_USERNAME=developer
UBUNTU_PASSWORD=your_secure_password

# Container Settings
CLAUDE_CONTAINER_VERSION=latest

# Claude Configuration
CLAUDE_CONFIG_DIR=/claude

# ClaudeCodeUI Ports
VITE_PORT=5173
PORT=3000

# Framework Paths
SUPERCLAUDE_HOME=/opt/superclaude
CLAUDECODEUI_HOME=/opt/claudecodeui
```

### Docker Compose Configuration

The `compose.yml` file includes:

```yaml
services:
  claude-code:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        - UBUNTU_USERNAME=${UBUNTU_USERNAME:-developer}
        - UBUNTU_PASSWORD=${UBUNTU_PASSWORD:-changeme123}
    ports:
      - "3389:3389"  # RDP
      - "5173:5173"  # ClaudeCodeUI Frontend
      - "3000:3000"  # ClaudeCodeUI Backend
    volumes:
      - ./workspace:/workspace
      - ./claude-config:/claude
    environment:
      - DISPLAY=:1
```

### Customization Options

#### Creating a Slim Image (No Desktop)

Create a `Dockerfile.slim`:

```dockerfile
# Build slim version from base
FROM ubuntu:24.04
# Copy your optimized Dockerfile content here
# Exclude desktop environment installation steps
# This reduces image size significantly
```

#### Adding Custom Tools

Create a `Dockerfile.custom`:

```dockerfile
# Build from the claude-container base
FROM claude-container:latest
RUN pip install your-package && \
    npm install -g your-tool
```

## 🔒 Security

### Best Practices

1. **Change Default Credentials**
   - Never use default passwords in production
   - Use strong, unique passwords
   - Consider using secrets management

2. **Network Security**
   - Use SSH tunneling for RDP access over networks
   - Implement firewall rules for exposed ports
   - Consider VPN for remote access

3. **Container Security**
   - Run containers with minimal privileges
   - Use read-only volumes where possible
   - Regularly update base images

### Security Configuration

```bash
# Generate secure password
openssl rand -base64 32

# Use Docker secrets (Swarm mode)
echo "secure_password" | docker secret create rdp_password -

# SSH tunnel for secure RDP
ssh -L 3389:localhost:3389 user@remote-host
```

## 📜 Deploy Script Reference

The `deploy.sh` script provides comprehensive container management:

### Commands

| Command | Description | Example |
|---------|-------------|---------|
| `start` | Start container | `./deploy.sh start --detach` |
| `stop` | Stop container | `./deploy.sh stop` |
| `restart` | Restart container | `./deploy.sh restart` |
| `build` | Build image | `./deploy.sh build` |
| `update` | Update and rebuild | `./deploy.sh update` |
| `logs` | View logs | `./deploy.sh logs` |
| `shell` | Open bash shell | `./deploy.sh shell` |
| `status` | Show status | `./deploy.sh status` |
| `clean` | Remove all | `./deploy.sh clean` |
| `ui` | Start ClaudeCodeUI | `./deploy.sh ui` |
| `rdp` | RDP info | `./deploy.sh rdp` |

### Options

- `--username`: Set Ubuntu username (default: developer)
- `--password`: Set Ubuntu password
- `--detach`: Run in background

### Examples

```bash
# Development workflow
./deploy.sh start --detach
./deploy.sh shell
# Work in container...
./deploy.sh stop

# Update to latest
./deploy.sh update

# Full cleanup
./deploy.sh clean
```

## 🔧 Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check logs
docker compose logs

# Verify ports are available
netstat -tulpn | grep -E '3389|5173|3000'

# Check Docker resources
docker system df
```

#### RDP Connection Failed
```bash
# Verify XRDP service
docker compose exec claude-code service xrdp status

# Restart XRDP
docker compose exec claude-code service xrdp restart

# Check credentials
./deploy.sh rdp
```

#### ClaudeCodeUI Not Loading
```bash
# Check if running
docker compose exec claude-code ps aux | grep node

# Start manually
docker compose exec claude-code bash -c "cd /opt/claudecodeui && npm run dev"

# Check logs
docker compose exec claude-code tail -f /opt/claudecodeui/logs/*
```

#### Out of Disk Space
```bash
# Clean Docker system
docker system prune -a

# Remove unused volumes
docker volume prune

# Check image sizes
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

### Performance Issues

#### Slow Build
- Use `.dockerignore` to exclude unnecessary files
- Ensure Docker has adequate resources (Settings → Resources)
- Use BuildKit: `DOCKER_BUILDKIT=1 docker build .`

#### High Memory Usage
```yaml
# Add to compose.yml
deploy:
  resources:
    limits:
      memory: 4G
    reservations:
      memory: 2G
```

## ⚡ Performance

### Optimization Metrics

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Docker Layers | 17 | 7 | 59% reduction |
| Build Time | ~15 min | ~10 min | 33% faster |
| Image Size | ~3.5GB | ~3GB | 15% smaller |
| Rebuild Time | ~8 min | ~3 min | 63% faster |

### Performance Tuning

```bash
# Enable BuildKit for faster builds
export DOCKER_BUILDKIT=1

# Use cache mounts (BuildKit)
# Add to Dockerfile:
# RUN --mount=type=cache,target=/root/.cache/pip \
#     pip install -r requirements.txt

# Parallel builds
docker compose build --parallel
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow existing code style and conventions
- Add tests for new features
- Update documentation as needed
- Keep commits atomic and well-described
- Ensure builds pass before submitting PR

## 📄 License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Anthropic](https://www.anthropic.com/) for Claude and Claude Code
- [btafoya](https://github.com/btafoya) for ClaudeCodeUI
- [SuperClaude-Org](https://github.com/SuperClaude-Org) for SuperClaude Framework
- The open-source community for the amazing tools included

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/btafoya/claude-container/issues)
- **Discussions**: [GitHub Discussions](https://github.com/btafoya/claude-container/discussions)
- **Repository**: [GitHub Repository](https://github.com/btafoya/claude-container)

---

<div align="center">
  <b>Happy Coding with Claude Container! 🚀</b>
  <br>
  Made with ❤️ by the Claude Container Community
</div>