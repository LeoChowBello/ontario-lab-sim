# SSH Quick Start

## Goal
Connect to the 13.x OpenEMR server before running the lab install command.

## Lab Server
For this lab, the server students connect to is:

`13.58.210.95`

That is the machine that hosts the OpenEMR 13.x exercise.

## What SSH Is
SSH means Secure Shell.

It is a way to open a command line on another computer over the network.

Use SSH when you need to:
- log into the 13.x OpenEMR server
- run the install script
- check files or settings on the remote machine

## What You Need
Before you connect, you need:
- the server address
- a username
- a password or private key, if your instructor gave you one

## What Students Should Expect
When SSH works, you will see a command prompt from the remote server.

That means:
- you are on the server now
- commands you type will run on the server, not on your own laptop

## Option 1: Windows PowerShell
Open PowerShell and run:

```powershell
ssh username@13.58.210.95
```

Replace `username` with the account name your instructor gave you.

If you use a private key, the command may look like this:

```powershell
ssh -i C:\path\to\your-key.pem username@13.58.210.95
```

## Option 2: Mac or Linux Terminal
Open Terminal and run:

```bash
ssh username@13.58.210.95
```

If you use a private key, the command may look like this:

```bash
ssh -i /path/to/your-key.pem username@13.58.210.95
```

## First Connection
The first time you connect, SSH may ask whether you trust the server fingerprint.

If the server address is correct and it matches what your instructor provided, type:

```text
yes
```

## What To Do After You Connect

Once you are on the server, you're ready to start the labs.

Continue with **Stage 1** labs in order:

1. [HL7 v2 Basics](HL7_V2_BASICS.md)
2. [LOINC Code Mapping Lab](LOINC_CODE_MAPPING_LAB.md)
3. [OpenEMR Database Concepts](OPENEMR_DATABASE_LAB.md)
4. [EDI File Exchange](EDI_FILE_EXCHANGE_LAB.md)
5. [Ontario OLIS Context](ONTARIO_OLIS_CONTEXT.md)

**Note on Mocklab Setup:**
Mocklab installation happens in Stage 2, not Stage 1. The setup script will handle database configuration and file directory creation automatically.

## If It Does Not Work

### SSH Connection Issues
Check these items:
- the server address is `13.58.210.95`
- the username is correct
- the private key path is correct
- the key file exists
- you are using the right server for the lab

If you still cannot connect, ask your instructor for the exact SSH details before trying again.

### FHIR API Not Working
If you get a 404 error when trying to access `/apis/default/fhir/metadata`:
1. Verify you completed Option A (run install.sh) OR Option B (manual setup) above
2. Check that the FHIR API checkbox is enabled in `Administration → Config → Connectors`
3. Ask your instructor if FHIR API was already enabled on the server

## Short Version
- SSH opens a command line on the 13.x server.
- You need the server address and username.
- Run `./install.sh` (Option A) OR manually enable FHIR via the Web UI (Option B).
- Then read the OpenEMR API Quick Start and continue with the labs.
