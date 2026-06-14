# Blocking Issue: Docker Daemon Not Responding

## Problem

Testing the full mocklab installation (--install and simulation) is blocked by Docker daemon connectivity.

```
Error: failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine
Unable to get image 'mariadb:10.11': failed to connect to the docker API
```

## What Works
✅ Config discovery (`python3 config_discovery.py`) — proven to correctly discover 8.0.x paths
✅ Docker client installed (`docker --version` works)
✅ Docker CLI responds to commands like `docker ps`

## What Doesn't Work
❌ Docker daemon not responding to API calls
❌ Cannot start containers
❌ Cannot run `docker exec` commands (needed for patch_php phase)
❌ Cannot pull images (mariadb:10.11)

## Root Cause
This is a WSL 2 backend initialization issue, likely because:
- Docker Desktop started in background but daemon didn't fully initialize
- WSL 2 backend service isn't responding
- Docker context might be pointing to wrong socket

## How to Resolve

**Manual Verification Required:**

1. **Check Docker Desktop Status:**
   - Look for Docker icon in system tray (bottom right of screen)
   - Icon should have a checkmark (✅ running)
   - If greyed out or missing, click to start it

2. **Wait for Full Initialization:**
   - Docker Desktop typically takes 2-3 minutes to fully start
   - Give it time after starting

3. **Confirm It's Working:**
   - Open PowerShell and run: `docker ps`
   - Should show list of containers (even if empty)
   - Should NOT show "failed to connect to docker API" error

4. **Tell us when Docker is ready:**
   - Once confirmed working, we can proceed with testing

## What We're Testing (Once Docker Works)

```bash
# Step 1: Start 8.0.x containers
docker-compose -f docker-compose-8.0.x.yml up -d

# Step 2: Run mocklab --install
# Expected: Creates /orders and /inbox, configures database, patches container
python3 ontario_lab_turnkey.py --install

# Step 3: Run mocklab simulator
# Expected: Starts Flask server, monitors /orders for lab orders
python3 ontario_lab_turnkey.py

# Step 4: Verify in OpenEMR
# Expected: Create lab order, mocklab processes it within 5 seconds
```

## Timeline

- **Config Discovery Test:** ✅ PASSED (2026-06-14 13:08 UTC)
- **--install Test:** ⏳ BLOCKED (awaiting Docker daemon)
- **Simulation Test:** ⏳ BLOCKED (awaiting Docker daemon)
- **Full Documentation:** ⏳ BLOCKED (awaiting 100% test completion)

---

**Next Step:** Verify Docker Desktop is running in your system tray, then confirm connectivity.
