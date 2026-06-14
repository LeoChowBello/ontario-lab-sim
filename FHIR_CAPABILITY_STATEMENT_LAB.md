# FHIR CapabilityStatement Mini Lab

## Why You're Learning This

You're learning about the CapabilityStatement because it answers a critical question: **"What can this server do?"** This is foundational knowledge for any integration work.

When you understand what OpenEMR advertises (what resources it supports, what operations are available), you can design integrations that match what the server is actually capable of. Mocklab uses a different approach (HL7 v2 files), but the principle is the same: know what the system supports before trying to integrate with it.

## Goal
Open the FHIR metadata page and record what the OpenEMR server advertises.

## Before You Start
OpenEMR must have the FHIR API enabled before this page will appear.

Go to:

`Administration -> Config -> Connectors`

Enable:

- `Enable OpenEMR Standard FHIR REST API`

On a fresh install, the public URL field is usually blank. Fill it in with the public server address so OpenEMR can build correct FHIR and OAuth links:

- `Site Address Override (if needed for OAuth2, FHIR, CCDA, or Payment Processing)`
- For the 13.x student lab, use: `https://13.58.210.95`

## Steps
1. Open the OpenEMR 13.x instance in your browser.
2. Go to this URL:

`https://13.58.210.95/apis/default/fhir/metadata`

3. Wait for the page to load.
4. Look for the word `CapabilityStatement`.
5. Record whether the page loaded.
6. Record the HTTP status code if your browser or tool shows it.
7. Write one sentence about what the page is for.

## What to Record
Write down:
- the URL you tested
- whether it loaded or failed
- the HTTP status code if available
- one sentence explaining what the CapabilityStatement is

## Hint
If you get stuck, use the API quick start first:
- `login.php` is the sign-in page
- `/swagger/` is the API documentation page
- `/fhir/metadata` is the FHIR discovery page

## Extension Question
If the page loads, look for:
- the FHIR version
- whether SMART-on-FHIR is mentioned
- the base URL the server advertises

If the page does not load, note that too.