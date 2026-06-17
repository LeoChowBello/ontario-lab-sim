# Ontario Lab Simulator Install Guide

## What this installer does

- Downloads the lab files into a temporary workspace
- Starts a fresh OpenEMR 8.x sandbox
- Starts the Ontario lab simulator
- Leaves your existing OpenEMR installations alone

## Install

Run this from an Ubuntu shell on the server:

```bash
curl -sSL https://raw.githubusercontent.com/LeoChowBello/ontario-lab-sim/main/install.sh | bash
```

## What you should see

- Docker containers starting
- A health check waiting for OpenEMR to be ready
- "Installation Complete" when the lab is ready

## Login

- URL: `http://localhost:8082`
- Username: `admin`
- Password: `pass`

If you are installing on a remote server, the script prints the correct access URL at the end.

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
- It explains the login credentials and next steps after installation.
- It avoids prompting for a sudo password when the server already has the needed Python packages.
