# OpenEMR Scopes: Beginner to Mid-Level Guide

## Why You're Learning This

You're learning about OAuth2 and scopes because **Mocklab must authenticate as an authorized app to write lab results back to OpenEMR**.

Without the right scopes, Mocklab can see what resources exist (via the metadata page) but cannot actually create DiagnosticReports or write patient data. Scopes are what grant Mocklab permission to do its job.

## Goal
Learn what scopes are and why they matter after you can already open the OpenEMR login page, Swagger page, and FHIR metadata page.

## What Is a Scope
A scope is a permission label that tells an app what it is allowed to do.

A scope can limit whether an app may:
- read data
- write data
- launch in a patient context
- access user-level data
- access system-level data

## What Is OAuth2
OAuth2 is the permission system that OpenEMR uses to decide what an app can do.

Think of it like this:
- the user signs in
- the app asks for permission
- OpenEMR checks the request
- OpenEMR either allows it or blocks it

OAuth2 is not the same thing as logging in.
- logging in proves who the user is
- OAuth2 decides what the app is allowed to access

## Why OAuth2 Matters
FHIR metadata tells you what the server supports.
Scopes and OAuth2 tell you what a specific app is allowed to do.

That means:
- metadata answers: "What can the server expose?"
- OAuth2 answers: "Can this app be trusted?"
- scopes answer: "What can this app actually use?"

## Learning Order
Use this order:

1. Open the login page.
2. Open Swagger.
3. Open the FHIR metadata page.
4. Read the CapabilityStatement.
5. Learn what scopes are.
6. Learn what OAuth2 is.
7. Learn how scopes and OAuth2 affect app access.
8. Learn how scopes and roles work together.

## Basic Ideas
### Read vs Write
- `read` means the app can look at data.
- `write` means the app can create or change data.

### Patient vs User vs System
- `patient` access is tied to a patient context.
- `user` access is tied to a logged-in user.
- `system` access is tied to the server or app itself.

### Redirect URL
When an app uses OAuth2, the browser is sent to a login or consent page and then sent back to a redirect URL.

That is why the public `Site Address Override` matters:
- if the server does not know its public URL, it may build the wrong redirect link
- if the redirect link is wrong, OAuth2 login can fail even if the API exists

## What Students Should Notice
When a lab asks about scopes, look for:
- which resources are named
- whether the scope is read-only or read-write
- whether the app is patient-facing or provider-facing
- whether the app needs manual approval
- whether the server requires OAuth2 to connect

## How This Relates to OpenEMR
In OpenEMR, scopes and OAuth2 are part of the access-control layer around FHIR.

That means a student may be able to:
- see the login page
- see Swagger
- open the FHIR metadata page

but still not be able to:
- pull real patient data
- call a protected resource
- complete an OAuth2 flow

## What Beginners Need to Know First
Before scopes make sense, students should already know:
- what an API is
- what FHIR is
- what the CapabilityStatement is
- why the server needs `Enable OpenEMR Standard FHIR REST API`
- why the public `Site Address Override` matters

## What Scopes Let You Learn Next
Once the basic pages work, scopes help students understand:
- why one app can read data and another cannot
- how a server limits access
- why interoperability is not just a URL
- how permissions affect data extraction

## Short Version
- FHIR metadata says what the server can expose.
- OAuth2 says how the app proves it should get access.
- Scopes say what the app can actually do.
- Roles and OAuth2 settings decide whether the app gets access.

## Companion Reading
Use this handout after:
- [OpenEMR API Quick Start](OPENEMR_API_QUICK_START.md)
- [FHIR CapabilityStatement Mini Lab](FHIR_CAPABILITY_STATEMENT_LAB.md)
- [OpenEMR 13.x Operability Exercise](OPENEMR_13X_EXERCISE.md)