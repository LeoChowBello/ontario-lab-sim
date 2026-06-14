# Ontario Lab Mocklab - Student Installation Guide

**Complete setup in ONE CLICK. Everything runs automatically.**

## Prerequisites

### For Windows:
- Docker Desktop installed and running
- ~5 GB disk space
- That's it! Python is not required.

### For Linux (Ubuntu):
- Docker and Docker Compose installed
- Python 3 with pip
- ~5 GB disk space

## Installation

### Option A: Windows Students (Easiest)

**Step 1: Open the folder**

Navigate to where you downloaded `ontario-lab-sim` and open it in File Explorer.

**Step 2: Double-click `install.bat`**

You'll see a console window open with progress messages:

```
============================================
 Ontario Lab Mocklab - Universal Installer
============================================

Step 1: Starting Docker containers...
   - OpenEMR database (MySQL)
   - OpenEMR web application  
   - Lab simulator

[Automatic download and setup happens...]

Waiting 60 seconds for services to initialize...
⏳ 60 seconds remaining...
[... counts down automatically ...]

Step 2: Configuring database and installing tests...
✅ Installation Complete!

OpenEMR:  http://localhost:8082
Mocklab:  http://localhost:5001
Login:    admin / pass
```

**Step 3: Press any key**

The console closes and everything is running in the background.

### Option B: Linux Students (Terminal)

**Step 1: Open terminal and navigate to the folder**

```bash
cd /path/to/ontario-lab-sim
```

**Step 2: Run the installer**

```bash
./install.sh
```

You'll see the same progress messages as Windows students.

**Step 3: Wait for completion**

The script will exit when installation is complete.

The installer automatically:
- ✓ Auto-discovers your OpenEMR configuration
- ✓ Creates EDI directories for file exchange
- ✓ Adds Ontario Reference Lab provider to database
- ✓ Adds all 6 lab tests (WBC, Hemoglobin, Glucose, TSH, Cholesterol, A1c)
- ✓ Sets up the lab simulator

## Installation Complete! ✅

Everything is now running in the background automatically:
- **OpenEMR web app:** http://localhost:8082
- **Mocklab simulator:** http://localhost:5001
- **Login credentials:** admin / pass
- **Database:** Automatically configured
- **Lab simulator:** Running continuously

## Testing the Setup (5 Minutes)

### Step 1: Open OpenEMR in Your Browser

Click this link or type it in the address bar:

```
http://localhost:8082
```

You'll see the OpenEMR login screen.

### Step 2: Login

- **Username:** admin
- **Password:** pass

Click the **Login** button.

### Step 3: Create a Test Patient

After login, look for the **Patients** menu on the left side. Click it.

Then click **Create Patient** (or find an existing test patient if one exists).

Fill in a few fields:
- **First Name:** John (or any name)
- **Last Name:** TestStudent
- **Date of Birth:** 01/01/1985
- Click **Save**

### Step 4: Create a Lab Order

On the patient's page, look for **Orders** or **Procedure Orders** in the left menu.

Click **New Order** or **New Procedure Order**.

In the search field, type one of these lab test codes:
- **6690-2** (WBC - White Blood Cell)
- **718-7** (Hemoglobin)
- **1558-6** (Glucose)
- **3016-3** (TSH)
- **2093-3** (Total Cholesterol)
- **4548-4** (Hemoglobin A1c)

Select the test and click **Save Order**.

### Step 5: Watch Mocklab Process It (Automatic!)

Wait 5-10 seconds.

The mocklab simulator automatically:
1. Detects the new order
2. Generates a realistic lab result
3. Sends it back to OpenEMR

The result appears in the patient's chart automatically. Look for a new **Result** or **Lab Result** entry.

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
