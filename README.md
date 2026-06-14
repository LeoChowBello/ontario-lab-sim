# Ontario Lab Simulator for OpenEMR

Use this repo as the student-facing lab packet.

## Why Ontario Context Matters

This lab simulator is specifically designed for Ontario healthcare interoperability.

In Ontario, **OLIS** (Ontario Laboratories Information System) is the provincial lab data exchange standard. This curriculum teaches you how lab integration works *using Ontario OLIS as the real-world example*.

**Mocklab** (in Stage 2) simulates an Ontario reference lab using OLIS protocols. Stage 1 teaches you the interoperability concepts you need to understand how OLIS integration works.

If you only need one link, open:
- [START_HERE.md](START_HERE.md)

If you want the lab in order, follow this path:

**Stage 1: Foundations for Mocklab**
1. [SSH Quick Start](SSH_QUICK_START.md)
2. [HL7 v2 Basics](HL7_V2_BASICS.md)
3. [LOINC Code Mapping Lab](LOINC_CODE_MAPPING_LAB.md)
4. [OpenEMR Database Concepts](OPENEMR_DATABASE_LAB.md)
5. [EDI File Exchange](EDI_FILE_EXCHANGE_LAB.md)
6. [Ontario OLIS Context](ONTARIO_OLIS_CONTEXT.md)

What you will learn:
- how to connect to the server with SSH
- how HL7 v2 messages work (the protocol Mocklab uses)
- how LOINC codes standardize test identifiers
- where Mocklab writes data in OpenEMR's database
- how order and result files flow through the system
- how Ontario's OLIS integrates with hospital labs

What to do first:
- connect to the server with SSH
- then follow the handouts in order

## Server Address

The 13.x server address is:
- `https://13.58.210.95`

See [SSH Quick Start](SSH_QUICK_START.md) for connection and setup instructions.

This simulator provides a mock Ontario Reference Lab that integrates with OpenEMR using standard HL7 v2.3 protocols.

## What Mocklab Means

- Mocklab is the simulated lab-side system.
- OpenEMR is the EHR side.
- Together they show how lab interoperability works end to end.

## What LOINC Means

- LOINC is the shared code system for lab tests and observations.
- It helps different systems agree that the same lab name means the same thing.

## For the Interop Team

**Stage 1-2 (HL7 v2 Integration):** Understand how Mocklab simulates Ontario OLIS using file-based HL7 v2 exchange:
- **terminology:** LOINC codes (how lab test names are standardized)
- **protocol:** HL7 v2 messages (order and result segments)
- **exchange:** EDI file flow (orders in, results out)
- **database:** OpenEMR procedure tables (where Mocklab writes data)

**Stage 3 (FHIR Integration):** Understand how modern FHIR apps extract data from OpenEMR:
- **surface:** login, Swagger, FHIR metadata (how OpenEMR exposes data)
- **access:** OAuth2 and scopes (how authorization controls what apps can read)
- **extraction:** building apps that read FHIR resources

## Advanced: Making Mocklab Universal

**For developers:** See [UNIVERSAL_MOCKLAB.md](UNIVERSAL_MOCKLAB.md) to understand how mocklab auto-discovers configuration from your docker-compose file.

This makes mocklab work on any OpenEMR version (7.0.2, 8.0.x, 9.0, etc.) without code changes—an important pattern for building production-grade interop tools.
