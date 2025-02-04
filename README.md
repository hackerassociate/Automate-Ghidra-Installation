# Automate-Ghidra-Installation [ Kali and Ubuntu ] 
This script automates the installation of Ghidra, a powerful software reverse engineering suite, on Kali Linux. It is designed to work seamlessly on both root and non-root environments, ensuring a smooth setup process.

<!DOCTYPE html>
<html>
<body>
<div class="markdown-body">

# Ghidra Installation Script for Kali Linux

[![Author](https://img.shields.io/badge/Author-Harshad%20Shah-blue.svg)](https://hackerassociate.com)
[![Website](https://img.shields.io/badge/Website-hackerassociate.com-green.svg)](https://hackerassociate.com)
[![Training](https://img.shields.io/badge/Training-blackhattrainings.com-red.svg)](https://blackhattrainings.com)

### Overview
This script automates the installation of Ghidra, a powerful software reverse engineering suite, on Kali Linux. It works seamlessly in both root and non-root environments, ensuring a smooth setup process.

The script:
- Installs all required dependencies (e.g., Java 17, wget, unzip)
- Downloads and extracts the latest version of Ghidra
- Configures system-wide environment variables (JAVA_HOME, PATH)
- Creates a desktop shortcut for easy access
- Adds an alias (ghidra) for quick terminal execution

### Features
- Automated Installation: No manual steps required
- Root-Compatible: Can be run as root for system-wide installation
- Desktop Shortcut: Adds a shortcut to the applications menu
- Alias Support: Adds a ghidra alias for terminal execution
- System-Wide Configuration: Sets up JAVA_HOME and PATH for all users

### Requirements
- Operating System: Kali Linux (tested on the latest version)
- Architecture: ARM64 or AMD64
- Privileges: Root privileges are recommended for system-wide installation

### Installation Steps

1. **Download the Script**
   Save the script to your system as `kali-ghidra-installer.sh`

2. **Make the Script Executable**
