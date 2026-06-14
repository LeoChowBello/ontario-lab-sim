# LOINC Code Mapping Lab

## Why You're Learning This

You're learning LOINC codes because they are **essential for Mocklab to work**. When Mocklab receives an order for "WBC count," it must match that order to the correct LOINC code (6690-2) in the database. If the codes don't match, the lab result cannot be connected to the original order.

In both FHIR and HL7 v2 approaches, LOINC codes are the standardization layer that makes interoperability possible. This is not optional—it's how systems agree on what a test actually is.

## Status
Use after students have completed HL7 v2 Basics and understand the importance of standardization.

## Goal
Learn how to find LOINC codes, map test names to standard identifiers, and connect those identifiers to the Mocklab workflow.

## Beginner Note
Students do not need to memorize LOINC codes.

They need to learn how to:
- search for the code
- copy the correct result
- connect the code to a test name
- understand why the same code matters in more than one system

## What LOINC Is
LOINC is the standard code system for lab tests, observations, and clinical measurements.

Use it when you need different systems to agree that the same test name means the same thing.

## Why This Lab Matters
Local test names are not enough for interoperability.

LOINC gives you:
- a shared code for a test name
- a way to compare results across systems
- a way to map OpenEMR and Mocklab data to the same identifier

## How to Get a LOINC Account
Use these steps:

1. Go to [loinc.org](https://loinc.org/).
2. Click `Sign Up` or `Log In` in the site header.
3. Create the free LOINC login.
4. Use that login for SearchLOINC, the Hierarchy Browser, and the LOINC downloads.

LOINC’s site requires a free login for browser tools and the complete file download.

## Tools Students Should Use
- [LOINC home](https://loinc.org/)
- [SearchLOINC](https://loinc.org/search/)
- [LOINC downloads](https://loinc.org/downloads/)

## Learning Sequence
1. Create a LOINC account.
2. Open SearchLOINC.
3. Search for common lab tests.
4. Fill in the missing LOINC codes.
5. Check the results against the simulator catalog.
6. Use Mocklab as the end goal for the mapping work.

## Fill-In Exercise
Use SearchLOINC to complete the missing codes.

| Test Name | LOINC Code | Notes |
| :--- | :--- | :--- |
| WBC | ________ | White blood cell count |
| Hemoglobin | ________ | Blood hemoglobin |
| Glucose (Fasting) | ________ | Fasting glucose |
| Hemoglobin A1c | ________ | Diabetes monitoring |
| Potassium | ________ | Electrolyte |
| Sodium | ________ | Electrolyte |
| Creatinine | ________ | Kidney function |
| Total Cholesterol | ________ | Lipid panel |

## Student Tasks
1. Search each test name in LOINC.
2. Fill in the missing code for each row.
3. Record the LOINC display name if it differs from the local lab name.
4. Compare your answers to the simulator catalog in the README.
5. Explain why the same test name must map to the same code in Mocklab and OpenEMR.

## What Students Should Learn
- local names and standard codes are not the same thing
- LOINC is the shared identifier layer
- mapping is part of interoperability, not an optional extra
- Mocklab depends on standardized codes to represent lab tests consistently

## Check Your Understanding
Answer these questions:
- Why is WBC not enough by itself?
- Why does a system need the code as well as the label?
- What changes when the same test is sent from Mocklab to OpenEMR using a standard code?
- What happens if two systems use different names for the same test?

## Next Step
After this lab, students should be able to move into the Mocklab workflow and recognize how lab orders and results depend on standardized test identifiers.

## Companion Reading
Use this lab after:
- [OpenEMR API Quick Start](OPENEMR_API_QUICK_START.md)
- [FHIR CapabilityStatement Mini Lab](FHIR_CAPABILITY_STATEMENT_LAB.md)
- [OpenEMR 13.x Operability Exercise](OPENEMR_13X_EXERCISE.md)
- [OpenEMR Scopes: Beginner to Mid-Level Guide](OpenEMR_Scopes_Beginner_Mid_Handout.md)