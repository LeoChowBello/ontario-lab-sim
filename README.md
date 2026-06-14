# Ontario Lab Simulator for OpenEMR

Use this repo as the student-facing lab packet.

## Why Ontario Context Matters

This lab simulator is specifically designed for Ontario healthcare interoperability.

In Ontario, **OLIS** (Ontario Laboratories Information System) is the provincial lab data exchange standard. This curriculum teaches you how lab integration works *using Ontario OLIS as the real-world example*.

**Mocklab** (in Stage 2) simulates an Ontario reference lab using OLIS protocols. Stage 1 teaches you the interoperability concepts you need to understand how OLIS integration works.

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
- how OpenEMR exposes its data through APIs
- how to navigate FHIR metadata and capabilities
- how OAuth2 and scopes control access to patient data
- how LOINC codes standardize test identifiers
- how these concepts enable Ontario OLIS lab integration (the focus of Stage 2)

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

If you are part of the interop team, understand the complete path that enables OLIS integration:
- **surface:** login, Swagger, FHIR metadata (how OpenEMR exposes data)
- **access:** OAuth2 and scopes (how authorization controls what apps can read)
- **terminology:** LOINC codes (how lab test names are standardized)
- **exchange:** Mocklab and OpenEMR together (how Ontario OLIS integration works end-to-end)
