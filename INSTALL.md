# Ontario Lab Simulator Install Guide

## What this installer does

- Downloads the lab files into a temporary workspace
- Starts a fresh OpenEMR 8.x sandbox
- Starts the Ontario lab simulator
- Verifies that the lab provider and procedure tests were inserted
- Leaves your existing OpenEMR installations alone

## Install

Run this from an Ubuntu shell on the server:

```bash
curl -sSL https://raw.githubusercontent.com/LeoChowBello/ontario-lab-sim/main/install.sh | bash
```

## What you should see

- Docker containers starting with a spinner
- A single-line progress bar while OpenEMR becomes healthy
- "Installation Complete" when the lab is ready

## Login

- URL: `http://localhost:8082`
- Username: `admin`
- Password: `pass`

If you are installing on a remote server, the script prints the correct access URL at the end.

## Available lab tests

These tests are loaded into the simulator and should appear in the Procedure Orders search menu:

- `6690-2` WBC
- `718-7` Hemoglobin
- `1558-6` Glucose (Fasting)
- `3016-3` TSH
- `2093-3` Total Cholesterol
- `4548-4` Hemoglobin A1c

## Available diagnosis codes

These diagnosis codes are seeded into OpenEMR so students can select a primary diagnosis for lab work:

- `R79.89` Other specified abnormal findings of blood chemistry
- `D64.9` Anemia, unspecified
- `E11.9` Type 2 diabetes mellitus without complications
- `E78.5` Hyperlipidemia, unspecified
- `E03.9` Hypothyroidism, unspecified
- `R73.03` Prediabetes
- `R53.83` Other fatigue
- `N18.9` Chronic kidney disease, unspecified
- `Z13.1` Encounter for screening for diabetes mellitus
- `Z13.220` Encounter for screening for lipoid disorders

## Chart diagnosis history

The installer also backfills the patient problem list with ICD-10 links so the diagnosis picker is not empty on first use. That means the `Primary Diagnosis` field in the order form should auto-fill from the chart history, and the history popup should show real entries students can select.

It also prepares the outgoing EDI orders folder so OpenEMR can write the HL7 file during transmit without a permissions error.

For the student sandbox, the collection-date and billing checks are relaxed so first-time users can complete the lab order flow without getting blocked by form setup details.

After a successful transmit, the simulator also triggers OpenEMR's result ingest path. Students should then open `Procedures -> Pending Review -> Procedure Results` to see the lab result appear in the normal OpenEMR workflow.

## Student lab order path

When you create the lab order for the first time, use this path inside the chart:

1. Open John Doe's chart
2. Open `Encounter`
3. Choose `Orders -> Procedure Orders`
4. If prompted, select John Doe
5. Click `New Order`
6. Select a test such as `3016-3 TSH`
7. Save the order

## Sudo note

- The installer first checks whether the needed Python modules are already installed.
- If they are, it skips package installation and does not need your Ubuntu password.
- If they are missing, it only uses `sudo` when passwordless access is available.
- If `sudo` needs a password, install the Python modules once as the server admin, then rerun the installer.

## If something goes wrong

- `Docker Compose not found`: install Docker and Docker Compose first.
- `Docker is not running`: start the Docker service and run the installer again.
- `OpenEMR did not become healthy`: wait a little longer and check the logs printed by the installer.
- `port is already allocated`: another lab is already using the same port, so stop that stack or change the ports.

## Why this version is better for students

- It does not assume the repo was cloned first.
- It downloads the files it needs automatically.
- It keeps the screen readable while OpenEMR starts.
- It verifies that the lab data was actually inserted before saying the install is complete.
- It tells students which lab tests are available before they open the order screen.
- It tells students which diagnosis codes are available before they open the order screen.
- It backfills chart diagnosis history so the diagnosis picker is usable right away.
- It explains the login credentials and next steps after installation.
- It avoids prompting for a sudo password when the server already has the needed Python packages.
