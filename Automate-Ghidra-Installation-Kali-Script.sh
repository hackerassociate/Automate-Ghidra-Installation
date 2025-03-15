#!/bin/bash

# =============================================
# Ghidra Installation Script for Kali Linux
# Author: Harshad Shah
# Version: 1.2
# Description: Automated installation script for Ghidra on Kali Linux (Root Compatible)
# =============================================

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${GREEN}[+] \$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] \$1${NC}"
}

print_error() {
    echo -e "${RED}[-] \$1${NC}"
}

print_info() {
    echo -e "${BLUE}[*] \$1${NC}"
}

print_banner() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════╗"
    echo "║       Ghidra Installer for Kali Linux     ║"
    echo "║          By: Harshad Shah & Bornunique911 ║"
    echo "╚═══════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Print banner
print_banner

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then 
    print_warning "It is recommended to run this script as root for system-wide installation."
    read -p "Do you want to continue without root? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create log file
LOG_FILE="ghidra_installation.log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

print_message "Starting Ghidra installation process..."
print_message "Installation log will be saved to $LOG_FILE"

# Check if running on Kali Linux
if ! grep -q "Kali" /etc/os-release; then
    print_warning "This script is optimized for Kali Linux. You might experience issues on other distributions."
    read -p "Do you want to continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Update system
print_message "Updating system packages..."
apt update && apt upgrade -y || {
    print_error "Failed to update system packages"
    exit 1
}

# Install required packages
print_message "Installing required packages..."
apt install -y openjdk-21-jdk openjdk-21-jre unzip wget curl git || {
    print_error "Failed to install required packages"
    exit 1
}

# Verify Java installation
print_message "Verifying Java installation..."
java -version || {
    print_error "Java installation failed"
    exit 1
}

# Create Ghidra directory
GHIDRA_DIR="/opt/ghidra"
print_message "Creating Ghidra directory at $GHIDRA_DIR"
mkdir -p "$GHIDRA_DIR"
cd "$GHIDRA_DIR" || exit 1

# Download Ghidra
GHIDRA_VERSION="11.3.1"
GHIDRA_RELEASE="20250219"
GHIDRA_FILE="ghidra_${GHIDRA_VERSION}_PUBLIC_${GHIDRA_RELEASE}.zip"
GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_VERSION}_build/${GHIDRA_FILE}"

print_message "Downloading Ghidra..."
wget "$GHIDRA_URL" || {
    print_error "Failed to download Ghidra"
    exit 1
}

# Extract Ghidra
print_message "Extracting Ghidra..."
unzip -q "$GHIDRA_FILE" || {
    print_error "Failed to extract Ghidra"
    exit 1
}

# Clean up zip file
print_message "Cleaning up..."
rm "$GHIDRA_FILE"

# Set permissions
print_message "Setting permissions..."
chmod +x "ghidra_${GHIDRA_VERSION}_PUBLIC/ghidraRun"

# Create desktop shortcut
print_message "Creating desktop shortcut..."
cat << EOF > /usr/share/applications/ghidra.desktop
[Desktop Entry]
Name=Ghidra
Comment=Ghidra Software Reverse Engineering Suite
Exec=$GHIDRA_DIR/ghidra_${GHIDRA_VERSION}_PUBLIC/ghidraRun
Icon=$GHIDRA_DIR/ghidra_${GHIDRA_VERSION}_PUBLIC/docs/images/GHIDRA_1.png
Terminal=false
Type=Application
Categories=Development;Reverse Engineering;
EOF

# Set up JAVA_HOME
# Check architecture and set appropriate Java path
if [ "$(uname -m)" = "aarch64" ]; then
    JAVA_PATH="/usr/lib/jvm/java-17-openjdk-arm64"
else
    JAVA_PATH="/usr/lib/jvm/java-17-openjdk-amd64"
fi

print_message "Setting up JAVA_HOME..."
echo "export JAVA_HOME=$JAVA_PATH" >> /etc/profile
echo "export PATH=\$PATH:$GHIDRA_DIR/ghidra_${GHIDRA_VERSION}_PUBLIC" >> /etc/profile

# Create alias for Ghidra
print_message "Creating alias for Ghidra..."
echo "alias ghidra='$GHIDRA_DIR/ghidra_${GHIDRA_VERSION}_PUBLIC/ghidraRun'" >> /etc/profile

# Apply changes
print_message "Applying changes..."
source /etc/profile

print_message "Installation completed successfully!"
print_info "You can start Ghidra using any of these methods:"
print_info "1. Type 'ghidra' in terminal"
print_info "2. Run: $GHIDRA_DIR/ghidra_${GHIDRA_VERSION}_PUBLIC/ghidraRun"
print_info "3. Use the desktop shortcut"

print_warning "Note: You may need to log out and log back in for all changes to take effect"

# Print system information for debugging
print_message "System Information:"
echo "Kali Version: $(cat /etc/os-release | grep "PRETTY_NAME" | cut -d'"' -f2)"
echo "Java Version: $(java -version 2>&1 | head -n 1)"
echo "Architecture: $(uname -m)"
echo "Memory: $(free -h | awk '/^Mem:/ {print \$2}')"

print_message "Installation log has been saved to $LOG_FILE"
