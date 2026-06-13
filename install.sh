#!/bin/bash
# 🏥 Ontario Lab Simulator: Student Auto-Installer
# This script is designed for fresh OpenEMR instances.

echo "=== 🏥 Ontario Lab Simulator: One-Click Installer ==="

# 1. Update and install Linux dependencies
echo "Checking system requirements..."
sudo apt-get update -qq && sudo apt-get install -y -qq python3-pip python3-flask python3-pymysql wget > /dev/null

# 2. Download the Turnkey script from your GitHub
echo "Downloading simulator engine..."
wget -q -O ontario_lab_turnkey.py https://raw.githubusercontent.com/LeoChowBello/ontario-lab-sim/main/ontario_lab_turnkey.py

# 3. Execute the installation (Automates DB and Service setup)
echo "Configuring OpenEMR integration (Direct Database Injection)..."
sudo python3 ontario_lab_turnkey.py --install

echo "=== 🎉 Installation Successful! ==="
echo "The lab is now active and integrated into your EMR."