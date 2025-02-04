#!/bin/bash

# =============================================
# Ghidra Installation Script for Ubuntu ARM
# Author: Harshad Shah
# Version: 1.0
# Description: Automated installation script for Ghidra on Ubuntu ARM
# =============================================

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run this script as root"
    exit 1
fi

# Create log file
LOG_FILE="ghidra_installation.log"
exec 1> >(tee -a "$LOG_FILE") 2>&1

print_message "Starting Ghidra installation process..."
print_message "Installation log will be saved to $LOG_FILE"

# Update system
print_message "Updating system packages..."
sudo apt update && sudo apt upgrade -y || {
    print_error "Failed to update system packages"
    exit 1
}

# Install required packages
print_message "Installing required packages..."
sudo apt install -y openjdk-17-jdk openjdk-17-jre unzip wget || {
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
GHIDRA_DIR="$HOME/ghidra"
print_message "Creating Ghidra directory at $GHIDRA_DIR"
mkdir -p "$GHIDRA_DIR"
cd "$GHIDRA_DIR" || exit 1

# Download Ghidra
GHIDRA_VERSION="11.0"
GHIDRA_RELEASE="20231222"
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
cat << EOF | sudo tee /usr/share/applications/ghidra.desktop
[Desktop Entry]
Name=Ghidra
Comment=Ghidra Software Reverse Engineering Suite
Exec=$GHIDRA_DIR/ghidra_${GHIDRA_VERSION}_PUBLIC/ghidraRun
Icon=$GHIDRA_DIR/ghidra_${GHIDRA_VERSION}_PUBLIC/docs/images/GHIDRA_1.png
Terminal=false
Type=Application
Categories=Development;
EOF

# Set up JAVA_HOME
JAVA_PATH="/usr/lib/jvm/java-17-openjdk-arm64"
print_message "Setting up JAVA_HOME..."
if ! grep -q "JAVA_HOME" "$HOME/.bashrc"; then
    echo "export JAVA_HOME=$JAVA_PATH" >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
fi

print_message "Installation completed successfully!"
print_message "You can start Ghidra by running: $GHIDRA_DIR/ghidra_${GHIDRA_VERSION}_PUBLIC/ghidraRun"
print_warning "Note: You may need to log out and log back in for the desktop shortcut to appear"

# Print system information for debugging
print_message "System Information:"
echo "Ubuntu Version: $(lsb_release -d)"
echo "Java Version: $(java -version 2>&1 | head -n 1)"
echo "Architecture: $(uname -m)"
echo "Memory: $(free -h | awk '/^Mem:/ {print $2}')"

print_message "Installation log has been saved to $LOG_FILE"