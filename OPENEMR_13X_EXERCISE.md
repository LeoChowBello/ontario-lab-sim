# OpenEMR 13.x Operability Exercise

## Why You're Learning This

You're learning the sequence of interoperability (login → Swagger → metadata → data access → access control) because **this is exactly what Mocklab does when it connects to OpenEMR**.

Understanding this sequence helps you recognize how lab integration works end-to-end and why each step matters.

## Purpose
Learn the order that makes OpenEMR interoperability understandable:
login page, API docs, FHIR metadata, CapabilityStatement, then actual data access.

## Learning Sequence
Use this order for beginners:

1. **Human surface**
   - Open the login page.
   - Learn that this is for people using the browser.

2. **API surface**
   - Open Swagger/OpenAPI.
   - Learn where the software endpoints are listed.

3. **FHIR enablement**
   - Check `Administration -> Config -> Connectors`.
   - Turn on `Enable OpenEMR Standard FHIR REST API`.
   - Set `Site Address Override` to `https://13.58.210.95` if needed.

4. **FHIR discovery**
   - Open `/apis/default/fhir/metadata`.
   - Learn what the server advertises in its CapabilityStatement.

5. **Data extraction**
   - Use the advertised resources and the right access rules to read actual data.

6. **Access control**
   - Learn that roles, OAuth2, and scopes decide what an app can do.

## Before You Start
OpenEMR must have the FHIR API enabled before the metadata page will show.

## Tasks
1. Open the OpenEMR login page.
2. Open the Swagger/OpenAPI page.
3. Open the FHIR metadata page.
4. Record what the CapabilityStatement tells you.
5. If the page does not load, note whether the FHIR setting may be off.

## Student URLs
- Login: `https://13.58.210.95/interface/login/login.php?site=default`
- Swagger: `https://13.58.210.95/swagger/`
- FHIR metadata: `https://13.58.210.95/apis/default/fhir/metadata`

## What to Record
Write down:
- which pages opened
- the HTTP status code if available
- 3 observations from the CapabilityStatement
- one sentence about what the server appears ready to support

## What Success Looks Like
- the login page opens
- Swagger opens
- the FHIR metadata page opens
- the student can explain what the server advertises
- the student can describe what would be needed to read real resources next

## Companion Reading
Use this handout alongside the exercise:

- [OpenEMR API Quick Start](OPENEMR_API_QUICK_START.md)
- [FHIR CapabilityStatement Mini Lab](FHIR_CAPABILITY_STATEMENT_LAB.md)
- [OpenEMR Scopes: Beginner to Mid-Level Guide](OpenEMR_Scopes_Beginner_Mid_Handout.md)