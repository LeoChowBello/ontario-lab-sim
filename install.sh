#!/bin/bash

echo ""
echo "============================================"
echo "  Ontario Lab Mocklab - Universal Installer"
echo "============================================"
echo ""

# Detect Docker Compose command (supports both old and new syntax)
if command -v docker-compose > /dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif command -v docker > /dev/null 2>&1 && docker compose version > /dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    echo "ERROR: Docker Compose not found."
    echo "Please install Docker and Docker Compose, then try again."
    exit 1
fi

echo "Step 1: Starting Docker containers..."
echo "   - OpenEMR database (MySQL)"
echo "   - OpenEMR web application"
echo "   - Lab simulator"
echo ""

$DOCKER_COMPOSE_CMD -f docker-compose-8.0.x.yml up -d

if [ $? -ne 0 ]; then
    echo "ERROR: Docker Compose failed. Make sure Docker is running."
    exit 1
fi

echo ""
echo "Waiting 60 seconds for services to initialize..."
sleep 60

echo ""
echo "Step 2: Configuring database and installing tests..."
echo ""

python3 ontario_lab_turnkey.py --install

if [ $? -ne 0 ]; then
    echo "ERROR: Installation failed."
    exit 1
fi

echo ""
echo "============================================"
echo "  ✅ Installation Complete!"
echo "============================================"
echo ""
echo "Your healthcare IT lab is now running."
echo ""

# Detect environment and get the right URL
if [ -z "$DISPLAY" ]; then
    # Headless environment (AWS, remote server, etc.)
    PUBLIC_IP=$(curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null)

    if [ -n "$PUBLIC_IP" ]; then
        ACCESS_URL="http://$PUBLIC_IP:8082"
    else
        LOCAL_IP=$(hostname -I | awk '{print $1}')
        ACCESS_URL="http://$LOCAL_IP:8082"
    fi

    echo "Access OpenEMR from your laptop:"
    echo "  $ACCESS_URL"
else
    # Local GUI environment
    ACCESS_URL="http://localhost:8082"
    echo "Opening browser..."
    if command -v xdg-open > /dev/null; then
        xdg-open "$ACCESS_URL" 2>/dev/null &
    elif command -v open > /dev/null; then
        open "$ACCESS_URL" 2>/dev/null &
    fi
fi

echo ""
echo "NEXT STEPS:"
echo "============================================"
echo ""
echo "1. OPEN YOUR BROWSER"
echo "   Go to: $ACCESS_URL"
echo ""
echo "2. LOGIN"
echo "   Enter your OpenEMR login credentials"
echo "   (Check docker-compose-8.0.x.yml if you need to verify them)"
echo ""
echo "3. CREATE A TEST PATIENT"
echo "   - Click 'Patients' menu"
echo "   - Click '+ New Patient'"
echo "   - Fill in: John, Doe, DOB: 01/01/1990"
echo "   - Click 'Save Patient'"
echo ""
echo "4. CREATE A LAB ORDER"
echo "   - Click the patient name"
echo "   - Click 'Orders' or 'New Order'"
echo "   - Search for: 3016-3 (TSH test)"
echo "   - Click 'Save Order'"
echo ""
echo "5. WATCH THE MAGIC"
echo "   - Wait 10-15 seconds"
echo "   - Refresh your browser"
echo "   - See the result appear automatically!"
echo ""
echo "THAT'S IT! You just used HL7 messaging like hospitals do."
echo ""
echo "For more help, see: INSTALL.md"
echo ""
