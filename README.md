# Ontario Lab Simulator for OpenEMR

Use this repo as the student-facing lab packet.

If you only need one link, open:
- [START_HERE.md](START_HERE.md)

If you want the lab in order, follow this path:
1. [SSH Quick Start](SSH_QUICK_START.md)
2. [OpenEMR API Quick Start](OPENEMR_API_QUICK_START.md)
3. [FHIR CapabilityStatement Mini Lab](FHIR_CAPABILITY_STATEMENT_LAB.md)
4. [OpenEMR 13.x Operability Exercise](OPENEMR_13X_EXERCISE.md)
5. [OpenEMR Scopes: Beginner to Mid-Level Guide](OpenEMR_Scopes_Beginner_Mid_Handout.md)
6. [LOINC Code Mapping Lab](LOINC_CODE_MAPPING_LAB.md)

What you will learn:
- how to connect to the 13.x server
- how to open OpenEMR
- how to find the API and FHIR metadata pages
- how OAuth2 and scopes affect access
- how LOINC codes connect lab names to Mocklab

What to do first:
- connect to the 13.x server with SSH
- enable the FHIR API using one of two methods (see SSH Quick Start)
- then follow the handouts in order

## FHIR API Setup

The FHIR API can be enabled in two ways:

**Option A: Automated (recommended for fresh installs)**
- Run `./install.sh` after SSH connection
- This automatically configures everything including FHIR API

**Option B: Manual via Web UI**
- Log in to OpenEMR as admin
- Go to: `Administration → Config → Connectors`
- Enable: `Enable OpenEMR Standard FHIR REST API`
- Set: `Site Address Override` to your server URL (e.g., `https://13.58.210.95`)

See [SSH Quick Start](SSH_QUICK_START.md) for detailed instructions.

The 13.x server address is:
- `https://13.58.210.95`

This simulator provides a mock Ontario Reference Lab that integrates with OpenEMR using standard HL7 v2.3 protocols.

## What Mocklab Means

- Mocklab is the simulated lab-side system.
- OpenEMR is the EHR side.
- Together they show how lab interoperability works end to end.

## What LOINC Means

- LOINC is the shared code system for lab tests and observations.
- It helps different systems agree that the same lab name means the same thing.

## For the Interop Team

If you are part of the interop team, focus on the path from surface to access:
- surface: login, Swagger, FHIR metadata
- access: OAuth2 and scopes
- terminology: LOINC codes
- exchange: Mocklab and OpenEMR together
