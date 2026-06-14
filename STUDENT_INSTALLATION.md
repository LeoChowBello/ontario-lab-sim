# Ontario Lab Mocklab - Student Installation Guide

**Complete setup in 2 commands. Everything runs automatically.**

## Prerequisites

- Docker and Docker Compose installed on Ubuntu Linux
- Python 3 with Flask and PyMySQL
- ~5 GB disk space

## Installation

### Step 1: Start All Services

```bash
cd /path/to/ontario-lab-sim

docker-compose -f docker-compose-8.0.x.yml up -d
```

This starts:
- ✓ OpenEMR database (MySQL)
- ✓ OpenEMR web application
- ✓ Ontario Lab Mocklab simulator (automatically)

Wait 60 seconds for OpenEMR to initialize.

### Step 2: Configure Everything

```bash
python3 ontario_lab_turnkey.py --install
```

This does:
- ✓ Auto-discovers your OpenEMR setup
- ✓ Creates EDI directories for file exchange
- ✓ Adds Ontario Reference Lab to database
- ✓ Adds all 6 lab tests (WBC, Hemoglobin, Glucose, TSH, Cholesterol, A1c)
- ✓ Patches validation logic for simplified orders

**Expected output:**
```
🚀 MOCKLAB UNIVERSAL INSTALL

Installing (using docker exec for database operations)...
  1. Creating EDI directories...
  2. Configuring OpenEMR database...
  ✓ Database configured
  3. Patching validation logic...
  ✅ Patch verified and stable.

🎉 Turnkey Install Complete.
```

## That's It!

Everything is now running automatically:
- OpenEMR at: http://localhost:8082
- Mocklab simulator at: http://localhost:5001 (running in background)
- Database ready for orders
- EDI file exchange ready

## Testing the Setup

### 1. Open OpenEMR

```
http://localhost:8082/interface/login/login.php
```

**Login:** admin / pass

### 2. Create a Patient (or find existing one)

Navigate to Patients section and create/find a test patient.

### 3. Create a Lab Order

- Find the patient
- Go to Orders or Labs section
- Create a new Procedure Order
- Select one of these tests:
  - **WBC** (6690-2)
  - **Hemoglobin** (718-7)
  - **Glucose** (1558-6)
  - **TSH** (3016-3)
  - **Total Cholesterol** (2093-3)
  - **Hemoglobin A1c** (4548-4)
- Save the order

### 4. Watch Mocklab Process It

- Wait 5-10 seconds
- The order file appears in `/orders`
- Mocklab processes it
- Result appears in `/inbox` as HL7 v2.3 message
- OpenEMR imports the result

## What You're Learning

### HL7 v2 Message Format

**Order (ORM^O01):**
```
MSH|^~\&|OPENEMR|CLINIC|ONTARIO|LAB|20260614120000||ORM^O01|MSG001|D|2.3
PID|1||12345^^^MRN||Doe^John||19750520|M
OBR|1|ORD001||6690-2^WBC^LN|||20260614|||||||||||F
```

**Result (ORU^R01):**
```
MSH|^~\&|ONTARIOLAB|LAB|OPENEMR|CLINIC|20260614120503||ORU^R01|MSG001|D|2.3
PID|1||12345^^^MRN||Doe^John||19750520|M
OBR|1|MSG001||6690-2^|||20260614120503|||||||||||F
OBX|1|NM|6690-2^WBC^LN||7.2|x10^9/L|4.0-11.0|N|||F
```

The mocklab generates random values within normal ranges.

## Architecture

```
┌─────────────────────────────────────────┐
│         Docker Compose Network          │
├─────────────┬──────────────┬────────────┤
│  OpenEMR    │   MySQL DB   │  Mocklab   │
│  :8082      │  :3306       │  :5001     │
│             │              │            │
│  Creates    │  Stores      │  Monitors  │
│  Orders     │  Tests       │  /orders   │
│             │  Generates   │  Writes    │
│             │  Results     │  /inbox    │
└─────────────┴──────────────┴────────────┘
```

## File Locations (Inside Containers)

- **Orders directory:** `/var/www/localhost/htdocs/openemr/sites/default/documents/edi/orders/`
- **Results directory:** `/var/www/localhost/htdocs/openemr/sites/default/documents/edi/inbox/`
- **Database config:** `/var/www/localhost/htdocs/openemr/sites/default/sqlconf.php`

## Monitoring

### Check if all services are running:

```bash
docker-compose -f docker-compose-8.0.x.yml ps
```

Should show:
- openemr-8x-mysql-1 (Up)
- openemr-8x-1 (Up)
- mocklab-1 (Up)

### Check mocklab logs:

```bash
docker-compose -f docker-compose-8.0.x.yml logs mocklab
```

### Stop everything:

```bash
docker-compose -f docker-compose-8.0.x.yml down
```

## Troubleshooting

### "Docker command not found"
```bash
docker --version
# If not installed, install Docker Desktop for Ubuntu
```

### "Mocklab container won't start"
```bash
# Check if ports 5001 and 8082 are in use
sudo lsof -i :5001
sudo lsof -i :8082

# If in use, stop other services or change docker-compose ports
```

### "No results appearing"
- Verify mocklab is running: `docker-compose ps`
- Check mocklab logs: `docker-compose logs mocklab`
- Verify order file was created in `/orders` directory
- Wait 10 seconds (watcher runs every 5 seconds)

## Summary

| Step | Command | Purpose |
|------|---------|---------|
| 1 | `docker-compose up -d` | Start OpenEMR + Mocklab |
| 2 | `python3 ontario_lab_turnkey.py --install` | Configure database |
| 3 | Create order in OpenEMR | Test the system |
| 4 | Wait 5 seconds | Mocklab processes it |
| 5 | View result in OpenEMR | See HL7 response |

That's the complete workflow. **No errors expected. Everything runs automatically.**

---

**Questions?** Check the technical documentation in UNIVERSAL_MOCKLAB.md or LINUX_STUDENT_SETUP.md.
