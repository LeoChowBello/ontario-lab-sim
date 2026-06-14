# OpenEMR API Quick Start

## Why You're Learning This

You're learning about APIs and FHIR because **Mocklab needs to understand how to communicate with OpenEMR**. 

When Mocklab sends lab results back, it doesn't use the browser UI—it uses the FHIR API. This lab teaches you the API terms and surfaces that Mocklab relies on.

## Goal
Find the OpenEMR API documentation, then use it to reach the FHIR CapabilityStatement.

## Before You Start

The FHIR API must be enabled before the metadata page will work.

**If you already ran `./install.sh`:** FHIR is already enabled. Skip to "Step 1: Open the Login Page" below.

**If you need to enable FHIR manually:** Log in to OpenEMR as an admin and follow these steps:

1. Log in to OpenEMR at: `https://13.58.210.95` (use your admin credentials)
2. Navigate to: `Administration → Config → Connectors`
3. Check the box: `Enable OpenEMR Standard FHIR REST API`
4. In the `Site Address Override` field, enter: `https://13.58.210.95`
5. Click Save

After these steps, the FHIR metadata page will be accessible.

## API Terms
Use these terms while you work:

- `API`: a way for software to talk to software
- `FHIR API`: an API that uses the HL7 FHIR standard
- `FHIR REST API`: a FHIR API that uses standard web methods and URLs
- `CapabilityStatement`: the metadata page that describes what the FHIR server exposes

## OAuth2 Terms
OAuth2 is the permission system that lets an app ask OpenEMR for access.

Use this simple model:
- a student logs in with a username and password
- an app asks for permission to use data
- OpenEMR decides what the app is allowed to do

OAuth2 matters because:
- the FHIR metadata page can show that the server exists
- OAuth2 decides whether an app can actually use protected data
- the server may need the correct public URL to build login and callback links

Use these terms while you work:
- `OAuth2`: a standard way for apps to request permission
- `redirect URL`: the page the server sends the browser back to after login or consent
- `scope`: a permission label that says what the app may access
- `client`: the app that is asking for access

## Connector Settings
Use this section as your reference.

### Required
- `Enable OpenEMR Standard FHIR REST API`
  - Turns on the FHIR metadata page and FHIR resource endpoints.

### Required on a fresh install
- `Site Address Override (if needed for OAuth2, FHIR, CCDA, or Payment Processing)`
  - Fill this in with the public base URL.
  - For the 13.x student lab, set it to `https://13.58.210.95`.
  - This lets OpenEMR advertise the correct external address for FHIR, OAuth2, and other integration links.

### Advanced or optional
- `Enable OpenEMR FHIR System Scopes (Turn on only if you know what you are doing)`
- `Enable OpenEMR Standard REST API`
- `Enable OpenEMR Patient Portal REST API (EXPERIMENTAL)`
- `Enable OAuth2 Password Grant (Not considered secure)`
- `On for Users Role`
- `OAuth2 App Manual Approval Settings`
- `Maximum supported version for US Core FHIR Implementation Guide`

## What This Lets You Do
If FHIR is enabled and you have access, you can:

- open the CapabilityStatement
- see what the server advertises
- check whether an integration can connect
- request patient or lab data
- test interoperability

## Steps
1. Open the OpenEMR login page.
2. Open the Swagger/OpenAPI page.
3. Open the FHIR metadata page.
4. Record the results.

## Step 1: Open the Login Page
Use this URL for the 13.x student lab:

`https://13.58.210.95/interface/login/login.php?site=default`

## Step 2: Open the API Documentation
Use this URL for Swagger/OpenAPI:

`https://13.58.210.95/swagger/`

## Step 3: Open the FHIR Metadata Page
Use this URL for the FHIR CapabilityStatement:

`https://13.58.210.95/apis/default/fhir/metadata`

## Step 4: Record Your Results
Write down:

- the login URL
- whether Swagger opened
- whether the FHIR metadata page opened
- the HTTP status code if available
- one sentence describing the CapabilityStatement

## Short Answer Template
- Login URL:
- Swagger URL:
- FHIR metadata URL:
- Status code:
- What the CapabilityStatement told me:
