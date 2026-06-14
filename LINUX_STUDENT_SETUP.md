# Mocklab Setup for Linux Students

**This guide is for Ubuntu/Linux students. All commands work cleanly on Linux.**

## Prerequisites

- Docker and Docker Compose installed
- OpenEMR 8.0.x running via docker-compose
- Python 3 with Flask and PyMySQL

## Installation (One Command)

```bash
cd /path/to/ontario-lab-sim

# Run the complete installation
python3 ontario_lab_turnkey.py --install
```

**Expected output:**
```
🔍 Discovering OpenEMR configuration from docker-compose file...
   ✅ Found docker-compose-8.0.x.yml
   ✅ Container: openemr-8x-1
   ✅ MySQL: openemr-8x-mysql-1
   ✅ Volume: openemr-8x-sites

🚀 MOCKLAB UNIVERSAL INSTALL

Installing (using docker exec for database operations)...
  1. Creating EDI directories...
  2. Configuring OpenEMR database...
  ✓ Database configured
  3. Patching validation logic...
  ✅ Patch verified and stable.

🎉 Turnkey Install Complete.
```

**What this does:**
- ✓ Creates `/orders` and `/inbox` EDI directories
- ✓ Adds Ontario Reference Lab provider to OpenEMR
- ✓ Adds all 6 lab tests (WBC, Hemoglobin, Glucose, TSH, Cholesterol, A1c)
- ✓ Patches OpenEMR validation to allow simplified order form

## Running the Simulator

```bash
# Start the mocklab simulator (runs on port 5001)
python3 ontario_lab_turnkey.py
```

**Expected output:**
```
🧪 Starting Ontario Lab Simulator on port 5001...
   Container: openemr-8x-1
   Monitoring: /var/www/localhost/htdocs/openemr/sites/default/documents/edi/orders
   Writing results to: /var/www/localhost/htdocs/openemr/sites/default/documents/edi/inbox

 * Running on http://0.0.0.0:5001
```

The simulator is now:
- ✓ Listening for HTTP requests on port 5001
- ✓ Monitoring the `/orders` directory every 5 seconds
- ✓ Processing lab orders automatically

## Testing Mocklab

### Create a Test Lab Order

Create an HL7 v2 order file:

```bash
cat > /tmp/test_order.txt << 'EOF'
MSH|^~\&|OPENEMR|CLINIC|ONTARIO|LAB|20260614120000||ORM^O01|MSG001|D|2.3
PID|1||12345^^^MRN||Doe^John||19750520|M
OBR|1|ORD001||6690-2^WBC^LN|||20260614|||||||||||F
EOF
```

### Copy to Orders Directory

```bash
docker cp /tmp/test_order.txt openemr-8x-1:/var/www/localhost/htdocs/openemr/sites/default/documents/edi/orders/
```

### Watch Mocklab Process It

```bash
# Wait 6 seconds (watcher runs every 5 seconds)
sleep 6

# Check results
docker exec openemr-8x-1 cat /var/www/localhost/htdocs/openemr/sites/default/documents/edi/inbox/RES_test_order.txt
```

**Expected result:**
```
MSH|^~\&|ONTARIOLAB|LAB|OPENEMR|CLINIC|20260614120503||ORU^R01|MSG001|D|2.3
PID|1||12345^^^MRN||Doe^John||19750520|M
OBR|1|MSG001||6690-2^|||20260614120503|||||||||||F
OBX|1|NM|6690-2^WBC^LN||7.2|x10^9/L|4.0-11.0|N|||F
```

Mocklab generated a result with a random WBC value (7.2 in this example).

## How It Works

1. **Config Discovery**: Auto-detects your OpenEMR 8.0.x configuration from docker-compose
2. **One-Shot Install**: Creates everything needed with one command
3. **Simulator**: Continuously monitors `/orders` for new lab requests
4. **Processing**: Generates realistic HL7 v2 results with random values in normal range
5. **Results**: Writes results to `/inbox` for OpenEMR to import

## File Locations (Inside Container)

- **Orders** (inbound): `/var/www/localhost/htdocs/openemr/sites/default/documents/edi/orders/`
- **Results** (outbound): `/var/www/localhost/htdocs/openemr/sites/default/documents/edi/inbox/`
- **Configuration**: `/var/www/localhost/htdocs/openemr/sites/default/sqlconf.php`

## Stopping the Simulator

```bash
Ctrl+C
```

## Troubleshooting

### "Docker command not found"
```bash
# Make sure Docker is installed
docker --version

# Or try with sudo
sudo docker ps
```

### "Config discovery failed"
- Make sure `docker-compose-*.yml` is in the current directory
- Make sure OpenEMR containers are running: `docker ps | grep openemr`

### "Could not connect to database"
- Verify MySQL container is healthy: `docker ps`
- Check credentials in sqlconf.php: `docker exec openemr-8x-1 cat /var/www/localhost/htdocs/openemr/sites/default/sqlconf.php`

### "No results generated"
- Check simulator is running: `curl http://localhost:5001/`
- Should return: `<h1>Ontario Lab Active ✅</h1>`
- Verify order file has correct format (HL7 v2.3)
- Check logs: `docker logs openemr-8x-1 2>&1 | tail -20`

## What Each Lab Test Code Means

| LOINC Code | Test Name | Units | Reference Range |
|-----------|-----------|-------|-----------------|
| 6690-2 | WBC | x10^9/L | 4.0-11.0 |
| 718-7 | Hemoglobin | g/L | 120.0-175.0 |
| 1558-6 | Glucose (Fasting) | mmol/L | 3.6-6.0 |
| 3016-3 | TSH | mIU/L | 0.32-4.00 |
| 2093-3 | Total Cholesterol | mmol/L | 0.0-5.2 |
| 4548-4 | Hemoglobin A1c | % | 4.0-6.0 |

## No Errors Expected

If you follow these steps on Ubuntu/Linux, you should see **no errors**. The mocklab is fully tested and production-ready.

All commands use `docker exec` which works seamlessly on Linux.

---

**Questions?** Check [UNIVERSAL_MOCKLAB.md](UNIVERSAL_MOCKLAB.md) for technical details about how auto-discovery works.
