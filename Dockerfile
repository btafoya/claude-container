# Use Ubuntu LTS as base image for better compatibility
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONPATH="/opt/superclaude:$PYTHONPATH" \
    NODE_PATH="/usr/lib/node_modules:$NODE_PATH" \
    CLAUDE_CONFIG_DIR=/claude \
    SUPERCLAUDE_HOME=/opt/superclaude \
    CLAUDECODEUI_HOME=/opt/claudecodeui \
    PATH="/root/.local/bin:$PATH" \
    VITE_PORT=5173 \
    PORT=3000

# Define build arguments for user credentials
ARG UBUNTU_USERNAME=developer
ARG UBUNTU_PASSWORD=changeme123

# Install all system dependencies, Python, Node.js, and create user in one layer
RUN apt-get update && apt-get install -y \
    curl wget git build-essential ca-certificates gnupg lsb-release \
    python3 python3-pip python3-venv python3-dev \
    gcc g++ make cmake pkg-config \
    libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev llvm \
    libncurses5-dev libncursesw5-dev xz-utils tk-dev \
    libgdbm-dev libnss3-dev libedit-dev libc6-dev \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    && python3 -m pip install --upgrade pip setuptools wheel \
    && pip install uv \
    && uv tool install uvx \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m ${UBUNTU_USERNAME} \
    && echo "${UBUNTU_USERNAME}:${UBUNTU_PASSWORD}" | chpasswd \
    && usermod -aG sudo ${UBUNTU_USERNAME}

# Install all Node.js packages and tools in one layer
RUN npm install -g \
    @anthropic-ai/claude-code \
    claude-conductor \
    typescript \
    ts-node \
    nodemon \
    pm2 \
    yarn \
    pnpm \
    @playwright/test \
    && npx -y playwright@latest install --with-deps \
    && playwright install-deps

# Install all Python packages in one layer
RUN pip install --no-cache-dir \
    numpy pandas matplotlib seaborn scikit-learn \
    jupyter notebook ipython \
    requests beautifulsoup4 lxml \
    python-dotenv pyyaml rich click \
    fastapi uvicorn httpx aiohttp

# Clone and setup all repositories in one layer
RUN git clone https://github.com/SuperClaude-Org/SuperClaude_Framework /opt/superclaude \
    && cd /opt/superclaude \
    && ([ -f requirements.txt ] && pip install -r requirements.txt || true) \
    && ([ -f package.json ] && npm install || true) \
    && git clone https://github.com/btafoya/claudecodeui /opt/claudecodeui \
    && cd /opt/claudecodeui \
    && npm install \
    && ([ -f .env.example ] && cp .env.example .env || true) \
    && mkdir -p /claude /workspace /home/${UBUNTU_USERNAME}/.claude /home/${UBUNTU_USERNAME}/.config \
    && chown -R ${UBUNTU_USERNAME}:${UBUNTU_USERNAME} /claude /workspace /home/${UBUNTU_USERNAME} /opt/claudecodeui

# Install desktop environment and XRDP in one layer
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y lubuntu-desktop xrdp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && adduser xrdp ssl-cert \
    && echo "startlubuntu" > /etc/xrdp/startwm.sh \
    && chmod +x /etc/xrdp/startwm.sh

# Create startup script
RUN cat > /startup.sh <<'EOF'
#!/bin/bash
# Start XRDP service
service xrdp start

# Set up environment
export HOME=/root
export PATH="/opt/superclaude/bin:$PATH"

# Initialize SuperClaude if needed
if [ -d "/opt/superclaude" ]; then
    echo "SuperClaude Framework available at /opt/superclaude"
fi

# Initialize claudecodeui if needed
if [ -d "/opt/claudecodeui" ]; then
    echo "ClaudeCodeUI available at /opt/claudecodeui"
    echo "To start ClaudeCodeUI: cd /opt/claudecodeui && npm run dev"
fi

# Check installed tools
echo "=== Installed Tools ==="
which claude && echo "✓ Claude Code is available"
which claude-conductor && echo "✓ claude-conductor is available"
which uvx && echo "✓ uvx Python tool runner is available"
which playwright && echo "✓ Playwright is available"
python3 --version && echo "✓ Python is available"
node --version && echo "✓ Node.js is available"

# Keep container running
tail -f /var/log/xrdp.log
EOF
RUN chmod +x /startup.sh

# Expose ports for RDP and claudecodeui
EXPOSE 3389 5173 3000

# Set working directory
WORKDIR /workspace

# Start services using JSON format
CMD ["/bin/bash", "/startup.sh"]