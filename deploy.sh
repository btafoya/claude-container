#!/bin/bash

# Claude Container Deployment Helper Script
# Usage: ./deploy.sh [command] [options]

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DEFAULT_USERNAME="developer"
DEFAULT_PASSWORD="changeme123"
CONTAINER_NAME="claude-code"
PROJECT_NAME="claude-container"

# Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print help information
show_help() {
    cat << EOF
Claude Container Deployment Helper

Usage: ./deploy.sh [command] [options]

Commands:
    start           Start the container (builds if needed)
    stop            Stop the container
    restart         Restart the container
    build           Build/rebuild the container image
    update          Pull latest changes and rebuild
    logs            Show container logs
    shell           Open a shell in the container
    status          Show container status
    clean           Stop and remove container, volumes, and images
    ui              Start ClaudeCodeUI interface
    rdp             Show RDP connection information
    help            Show this help message

Options:
    --username      Set Ubuntu username (default: $DEFAULT_USERNAME)
    --password      Set Ubuntu password (default: $DEFAULT_PASSWORD)
    --detach        Run container in detached mode (for start/restart)

Examples:
    ./deploy.sh start --username john --password secretpass
    ./deploy.sh start --detach
    ./deploy.sh logs
    ./deploy.sh shell
    ./deploy.sh ui

RDP Connection:
    After starting, connect via RDP to localhost:3389
    Use the username and password specified during deployment

Web Interface:
    ClaudeCodeUI: http://localhost:5173 (after running './deploy.sh ui')

EOF
}

# Parse command line arguments
COMMAND="${1:-help}"
shift || true

UBUNTU_USERNAME="${DEFAULT_USERNAME}"
UBUNTU_PASSWORD="${DEFAULT_PASSWORD}"
DETACH_MODE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --username)
            UBUNTU_USERNAME="$2"
            shift 2
            ;;
        --password)
            UBUNTU_PASSWORD="$2"
            shift 2
            ;;
        --detach|-d)
            DETACH_MODE="-d"
            shift
            ;;
        *)
            print_message "$RED" "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Export environment variables for docker-compose
export UBUNTU_USERNAME
export UBUNTU_PASSWORD
export UID=$(id -u)
export GID=$(id -g)

# Execute commands
case $COMMAND in
    start)
        print_message "$GREEN" "Starting Claude Container..."
        print_message "$BLUE" "Username: $UBUNTU_USERNAME"
        print_message "$BLUE" "Password: [hidden]"
        
        # Create .env file if it doesn't exist
        if [ ! -f .env ]; then
            cat > .env << EOF
UBUNTU_USERNAME=$UBUNTU_USERNAME
UBUNTU_PASSWORD=$UBUNTU_PASSWORD
UID=$UID
GID=$GID
EOF
            print_message "$YELLOW" "Created .env file with configuration"
        fi
        
        docker compose build
        docker compose up $DETACH_MODE
        
        if [ -n "$DETACH_MODE" ]; then
            print_message "$GREEN" "Container started in detached mode"
            print_message "$BLUE" "RDP available at: localhost:3389"
            print_message "$BLUE" "Run './deploy.sh ui' to start ClaudeCodeUI"
            print_message "$BLUE" "Run './deploy.sh logs' to view logs"
        fi
        ;;
        
    stop)
        print_message "$YELLOW" "Stopping Claude Container..."
        docker compose stop
        print_message "$GREEN" "Container stopped"
        ;;
        
    restart)
        print_message "$YELLOW" "Restarting Claude Container..."
        docker compose restart
        print_message "$GREEN" "Container restarted"
        ;;
        
    build)
        print_message "$BLUE" "Building Claude Container image..."
        print_message "$BLUE" "Username: $UBUNTU_USERNAME"
        docker compose build --no-cache
        print_message "$GREEN" "Build completed"
        ;;
        
    update)
        print_message "$BLUE" "Updating Claude Container..."
        
        # Pull latest changes if in a git repository
        if [ -d .git ]; then
            print_message "$YELLOW" "Pulling latest changes from git..."
            git pull
        fi
        
        # Rebuild the container
        print_message "$BLUE" "Rebuilding container..."
        docker compose build --no-cache
        
        # Restart if running
        if docker compose ps | grep -q "Up"; then
            print_message "$YELLOW" "Restarting container..."
            docker compose down
            docker compose up $DETACH_MODE
        fi
        
        print_message "$GREEN" "Update completed"
        ;;
        
    logs)
        print_message "$BLUE" "Showing container logs (Ctrl+C to exit)..."
        docker compose logs -f
        ;;
        
    shell)
        print_message "$BLUE" "Opening shell in container..."
        docker compose exec -it ${CONTAINER_NAME} /bin/bash
        ;;
        
    status)
        print_message "$BLUE" "Container Status:"
        docker compose ps
        echo ""
        print_message "$BLUE" "Port Mappings:"
        docker compose port ${CONTAINER_NAME} 3389 2>/dev/null && echo "  RDP: $(docker compose port ${CONTAINER_NAME} 3389 2>/dev/null)"
        docker compose port ${CONTAINER_NAME} 5173 2>/dev/null && echo "  ClaudeCodeUI Frontend: $(docker compose port ${CONTAINER_NAME} 5173 2>/dev/null)"
        docker compose port ${CONTAINER_NAME} 3000 2>/dev/null && echo "  ClaudeCodeUI Backend: $(docker compose port ${CONTAINER_NAME} 3000 2>/dev/null)"
        ;;
        
    clean)
        print_message "$RED" "WARNING: This will remove the container, volumes, and images!"
        read -p "Are you sure? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_message "$YELLOW" "Cleaning up Claude Container..."
            docker compose down -v --rmi all
            rm -f .env
            print_message "$GREEN" "Cleanup completed"
        else
            print_message "$YELLOW" "Cleanup cancelled"
        fi
        ;;
        
    ui)
        print_message "$BLUE" "Starting ClaudeCodeUI..."
        
        # Check if container is running
        if ! docker compose ps | grep -q "Up"; then
            print_message "$RED" "Container is not running. Start it first with './deploy.sh start'"
            exit 1
        fi
        
        print_message "$GREEN" "Starting ClaudeCodeUI server..."
        print_message "$BLUE" "Frontend will be available at: http://localhost:5173"
        print_message "$BLUE" "Backend API at: http://localhost:3000"
        print_message "$YELLOW" "Press Ctrl+C to stop the UI server"
        
        docker compose exec ${CONTAINER_NAME} bash -c "cd /opt/claudecodeui && npm run dev"
        ;;
        
    rdp)
        print_message "$BLUE" "RDP Connection Information:"
        echo ""
        print_message "$GREEN" "  Server: localhost:3389"
        print_message "$GREEN" "  Username: $UBUNTU_USERNAME"
        print_message "$GREEN" "  Password: [set during deployment]"
        echo ""
        print_message "$YELLOW" "RDP Clients:"
        echo "  - Windows: Use Remote Desktop Connection (mstsc.exe)"
        echo "  - Mac: Download Microsoft Remote Desktop from App Store"
        echo "  - Linux: Use Remmina or rdesktop"
        ;;
        
    help)
        show_help
        ;;
        
    *)
        print_message "$RED" "Unknown command: $COMMAND"
        show_help
        exit 1
        ;;
esac

exit 0