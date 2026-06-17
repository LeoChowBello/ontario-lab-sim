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
- It explains the login credentials and next steps after installation.
- It avoids prompting for a sudo password when the server already has the needed Python packages.
