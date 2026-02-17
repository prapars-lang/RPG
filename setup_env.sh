#!/bin/bash
# setup_env.sh - Quick setup script for macOS and Linux
# Run this file to configure OpenCode API key

echo "============================================================"
echo "Educational Fantasy RPG - Configuration Setup"
echo "============================================================"
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    echo ""
    echo "Please install Python 3:"
    echo "  macOS (via Homebrew): brew install python"
    echo "  Ubuntu/Debian: sudo apt install python3"
    echo "  Fedora: sudo dnf install python3"
    echo ""
    exit 1
fi

echo "Python 3 found! Running setup script..."
echo ""

# Run the Python setup script
python3 setup_env.py

if [ $? -eq 0 ]; then
    echo ""
    echo "Setup completed successfully!"
    echo "You can now run the game in Godot!"
else
    echo ""
    echo "Setup failed!"
    exit 1
fi
