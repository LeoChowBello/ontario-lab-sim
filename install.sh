#!/bin/bash
set -euo pipefail

echo ""
echo "============================================"
echo "  Ontario Lab Mocklab - Universal Installer"
echo "============================================"
echo ""

REPO_BASE="https://raw.githubusercontent.com/LeoChowBello/ontario-lab-sim/main"
WORKDIR="$(mktemp -d "${TMPDIR:-/tmp}/ontario-lab-sim.XXXXXX")"

cleanup() {
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

download_file() {
    local url="$1"
    local dest="$2"

    if ! command -v python3 >/dev/null 2>&1; then
        echo "ERROR: python3 is required to download the installer files."
        exit 1
    fi

    python3 - "$url" "$dest" <<'PY'
from sys import argv
from urllib.request import urlopen

url = argv[1]
dest = argv[2]

with urlopen(url) as response, open(dest, 'wb') as fh:
    fh.write(response.read())
PY
}

python_has_module() {
    python3 - "$1" <<'PY' >/dev/null 2>&1
import importlib.util
import sys
module = sys.argv[1]
sys.exit(0 if importlib.util.find_spec(module) else 1)
PY
}

if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    echo "ERROR: Docker Compose not found."
    echo "Please install Docker and Docker Compose, then try again."
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker is not running. Start Docker and try again."
    exit 1
fi

echo "Step 0: Preparing a clean workspace..."
echo "   Downloading the lab files into: $WORKDIR"

download_file "$REPO_BASE/docker-compose-8.0.x.yml" "$WORKDIR/docker-compose-8.0.x.yml"
download_file "$REPO_BASE/Dockerfile" "$WORKDIR/Dockerfile"
download_file "$REPO_BASE/config_discovery.py" "$WORKDIR/config_discovery.py"
download_file "$REPO_BASE/ontario_lab_turnkey.py" "$WORKDIR/ontario_lab_turnkey.py"

cd "$WORKDIR"

echo ""
echo "Step 1: Checking host Python dependencies..."
missing_deps=0
for module in flask pymysql; do
    if python_has_module "$module"; then
        echo "   - $module: installed"
    else
        echo "   - $module: missing"
        missing_deps=1
    fi
done

if [ "$missing_deps" -ne 0 ]; then
    if sudo -n true >/dev/null 2>&1; then
        echo ""
        echo "Installing missing Python dependencies with sudo..."
        sudo apt-get update -qq
        sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq python3-pip python3-flask python3-pymysql >/dev/null
    else
        echo ""
        echo "ERROR: Python dependencies are missing and sudo is not available without a password."
        echo "Please install python3-flask and python3-pymysql as the server admin, then rerun the installer."
        exit 1
    fi
else
    echo ""
    echo "Python dependencies already present. Skipping package install."
fi

echo ""
echo "Step 2: Starting Docker containers..."
echo "   - OpenEMR database (MySQL)"
echo "   - OpenEMR web application"
echo "   - Lab simulator"
echo ""

$DOCKER_COMPOSE_CMD -f docker-compose-8.0.x.yml up -d --build

echo ""
echo "Step 3: Waiting for OpenEMR to become healthy..."
status="starting"
for attempt in $(seq 1 60); do
    status=$(docker inspect -f '{{.State.Health.Status}}' openemr-8x-1 2>/dev/null || echo starting)
    echo "   [$attempt/60] OpenEMR status: $status"
    if [ "$status" = "healthy" ]; then
        break
    fi
    sleep 10
done

if [ "$status" != "healthy" ]; then
    echo "ERROR: OpenEMR did not become healthy."
    echo "Check the container logs with: $DOCKER_COMPOSE_CMD -f docker-compose-8.0.x.yml logs --tail=100"
    exit 1
fi

echo ""
echo "Step 4: Configuring the database and installing tests..."
echo ""
python3 ontario_lab_turnkey.py --install

echo ""
echo "============================================"
echo "  Installation Complete"
echo "============================================"
echo ""
echo "OpenEMR login:"
echo "  URL:      http://localhost:8082"
echo "  Username: admin"
echo "  Password: pass"
echo ""

# Detect environment and get the right URL
if [ -z "${DISPLAY:-}" ]; then
    PUBLIC_IP=$(python3 - <<'PY'
import urllib.request
try:
    with urllib.request.urlopen("http://169.254.169.254/latest/meta-data/public-ipv4", timeout=1) as response:
        print(response.read().decode().strip())
except Exception:
    pass
PY
)

    if [ -n "$PUBLIC_IP" ]; then
        ACCESS_URL="http://$PUBLIC_IP:8082"
    else
        LOCAL_IP=$(hostname -I | awk '{print $1}')
        ACCESS_URL="http://$LOCAL_IP:8082"
    fi

    echo "Access OpenEMR from your laptop:"
    echo "  $ACCESS_URL"
else
    ACCESS_URL="http://localhost:8082"
    echo "Opening browser..."
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$ACCESS_URL" 2>/dev/null &
    elif command -v open >/dev/null 2>&1; then
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
echo "   Username: admin"
echo "   Password: pass"
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
