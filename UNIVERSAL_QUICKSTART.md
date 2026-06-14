# Universal Mocklab Quick Start

## For Students: Setup in 3 Commands

### Prerequisites
- Docker and Docker Compose installed
- OpenEMR running via `docker-compose-*.yml`
- Python 3 available

### Setup Steps

#### Step 1: Discover Your Configuration
```bash
cd /path/to/ontario-lab-sim

# Test that mocklab can auto-discover your OpenEMR setup
python3 config_discovery.py
```

You should see:
```
🔍 Discovering OpenEMR configuration from docker-compose file...
   Found: docker-compose-8.0.x.yml
   ✅ OpenEMR service: openemr-8x
   ✅ Container: openemr-8x-1
   ✅ MySQL: openemr-8x-mysql-1
   ✅ Volume: openemr-8x-sites
   ✅ Mount path: /var/www/localhost/htdocs/openemr/sites
   ✅ EDI base: /var/www/localhost/htdocs/openemr/sites/default/documents/edi
```

If you see an error, check:
- Are you in the same directory as `docker-compose*.yml`?
- Is your OpenEMR docker-compose running?
- Does your docker-compose have a service containing "openemr"?

#### Step 2: Install Mocklab (Requires Sudo)
```bash
python3 ontario_lab_turnkey.py --install
```

This will:
1. Create `/orders` and `/inbox` directories
2. Set permissions (requires `sudo`)
3. Add "Ontario Reference Lab" provider to OpenEMR database
4. Patch OpenEMR's validation logic
5. Print a success message

You should see:
```
🚀 MOCKLAB UNIVERSAL INSTALL

Setup sequence:
  1. Create EDI directories in /var/www/localhost/htdocs/openemr/sites/default/documents/edi
  2. Set permissions (sudo required)
  3. Auto-configure OpenEMR database (using openemr-8x-1)
  4. Patch validation logic

[... installing ...]

🎉 Turnkey Install Complete.
Mocklab is now configured for OpenEMR in openemr-8x-1
To start the lab simulator, run: python3 ontario_lab_turnkey.py
```

#### Step 3: Start the Lab Simulator
```bash
python3 ontario_lab_turnkey.py
```

You should see:
```
🧪 Starting Ontario Lab Simulator on port 5001...
   Container: openemr-8x-1
   Monitoring: /var/www/localhost/htdocs/openemr/sites/default/documents/edi/orders
   Writing results to: /var/www/localhost/htdocs/openemr/sites/default/documents/edi/inbox

 * Running on http://0.0.0.0:5001
```

Mocklab is now running in the background.

---

## Testing Mocklab

### 1. Check Flask Status (Optional)
```bash
curl http://localhost:5001/
```

Should return:
```html
<h1>Ontario Lab Active ✅</h1>
```

### 2. Create a Lab Order in OpenEMR

From OpenEMR web interface:
1. Log in as `admin` / `pass`
2. Find a patient
3. Click "Labs" or "Orders"
4. Create an order for one of the 6 available tests:
   - WBC (6690-2)
   - Hemoglobin (718-7)
   - Glucose (1558-6)
   - TSH (3016-3)
   - Cholesterol (2093-3)
   - A1c (4548-4)

### 3. Watch Mocklab Process It

Mocklab monitors `/orders` every 5 seconds. When you submit an order:
1. OpenEMR writes an HL7 v2 order file to `/orders`
2. Mocklab reads it (within 5 seconds)
3. Mocklab generates a realistic result with random values
4. Mocklab writes the result file to `/inbox`
5. OpenEMR imports the result

You can watch in real-time:
```bash
# Terminal 1: Watch orders directory
watch -n 1 "ls -la /path/to/openemr/sites/default/documents/edi/orders/"

# Terminal 2: Watch results directory
watch -n 1 "ls -la /path/to/openemr/sites/default/documents/edi/inbox/"
```

---

## How the Auto-Discovery Works

When you run `config_discovery.py` or `ontario_lab_turnkey.py`:

1. **Find** the docker-compose file in your directory
   - Looks for: `docker-compose*.yml` or `docker-compose*.yaml`

2. **Parse** the YAML to extract:
   - OpenEMR service name (e.g., "openemr-8x")
   - OpenEMR container name (e.g., "openemr-8x-1")
   - MySQL container name (e.g., "openemr-8x-mysql-1")
   - Docker volume name (e.g., "openemr-8x-sites")
   - Mount path inside container (e.g., "/var/www/localhost/htdocs/openemr/sites")

3. **Calculate** the paths mocklab needs:
   - EDI_BASE: `{mount_path}/default/documents/edi`
   - DB_CONFIG: `{mount_path}/default/sqlconf.php`

4. **Use** these discovered values instead of hardcoded ones

Result: **Same mocklab code works on any OpenEMR version.**

---

## Common Issues

### Issue: "No docker-compose file found"

**Solution:** Make sure you're in the correct directory.

```bash
# Correct:
cd ~/my-openemr-setup
ls docker-compose*.yml          # Should show a file
python3 ontario_lab_turnkey.py --install

# Incorrect:
cd ~/Downloads
python3 ontario_lab_turnkey.py --install  # ❌ docker-compose.yml not here
```

### Issue: "Could not find OpenEMR service"

**Check your docker-compose file:**
```bash
grep -A3 "services:" docker-compose*.yml
```

The service name must contain "openemr" (not just "web" or "app").

Example valid names:
- `openemr-8x` ✅
- `openemr` ✅
- `openemr-main` ✅
- `web` ❌ (doesn't contain "openemr")

### Issue: "docker exec ... cp: command not found"

**Root cause:** The file doesn't exist in the container, or the container isn't running.

**Solution:**
```bash
# Verify container is running
docker ps | grep openemr

# Verify the file exists
docker exec openemr-8x-1 ls -la /var/www/localhost/htdocs/openemr/interface/forms/procedure_order/common.php
```

### Issue: "Permission denied" on sudo chmod

**Solution:** Make sure you have sudo access.

```bash
# If your user isn't in the docker group:
sudo usermod -aG docker $USER
# Then log out and back in
```

---

## Next Steps

- Read [UNIVERSAL_MOCKLAB.md](UNIVERSAL_MOCKLAB.md) to understand the architecture
- Review [HL7_V2_BASICS.md](HL7_V2_BASICS.md) to understand order/result messages
- Check [EDI_FILE_EXCHANGE_LAB.md](EDI_FILE_EXCHANGE_LAB.md) to understand file flow

---

## Summary

| Step | Command | What It Does |
|------|---------|-------------|
| 1 | `python3 config_discovery.py` | Verify mocklab can find your OpenEMR setup |
| 2 | `python3 ontario_lab_turnkey.py --install` | Configure mocklab (one-time setup) |
| 3 | `python3 ontario_lab_turnkey.py` | Start the lab simulator |

That's it! Mocklab is now simulating an Ontario reference lab for your OpenEMR instance.
