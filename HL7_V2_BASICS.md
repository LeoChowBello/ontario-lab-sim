# HL7 v2 Basics

## Why You're Learning This

Mocklab uses **HL7 v2** to communicate with OpenEMR. Unlike modern FHIR (which uses JSON over HTTP), HL7 v2 is a text-based protocol where messages are exchanged as files. Understanding the message structure helps you recognize what's happening when Mocklab sends orders and results.

## What HL7 v2 Is

HL7 v2 (Health Level 7 version 2) is a messaging standard created in 1989 for healthcare systems to exchange data.

Key facts:
- **Text-based, not JSON** — uses pipe (`|`) and caret (`^`) delimiters
- **Segment-based** — messages are made of labeled lines (segments)
- **Still widely used** — especially in labs and hospitals for legacy systems
- **Still standard in Ontario** — OLIS uses HL7 v2.3 for lab communication

## Basic Structure: Segments

An HL7 v2 message is made of **segments**. Each segment starts with a 3-letter code.

### Common Lab Segments

**MSH (Message Header)**
- The first segment in every HL7 message
- Contains metadata: sender, receiver, timestamp, message type
- Example: `MSH|^~\\&|ONTARIOLAB|LAB|OPENEMR|CLINIC|20260614100000||ORU^R01|12345|D|2.3`

**PID (Patient Identity)**
- Identifies the patient
- Contains: patient ID, name, date of birth, sex
- Example: `PID|1|MRN123||||Doe^John||19801015|M`

**OBR (Observation Request)**
- Describes a lab test order or result set
- Contains: test code, specimen type, status
- Example: `OBR|1|ORD123||6690-2^WBC^LN|||20260614100000`

**OBX (Observation Result)**
- Contains the actual test result
- Contains: result code, value, units, reference range
- Example: `OBX|1|NM|6690-2^WBC^LN||7.5|x10^9/L|4.0-11.0|N|||F`

## Reading a Sample HL7 v2 Message

Here's an order for a WBC test:

```
MSH|^~\\&|OPENEMR|CLINIC|ONTARIOLAB|LAB|20260614100000||ORM^O01|MSG123|D|2.3
PID|1|MRN456||||Smith^Jane||19800101|F
OBR|1|ORD789||6690-2^WBC^LN|||20260614100000|||||||||||||F
```

What this says:
- MSH: Message from OpenEMR clinic to Ontario Lab, timestamp 2026-06-14 10:00:00
- PID: Patient MRN456, Jane Smith, female, DOB 1980-01-01
- OBR: Order #789, test code 6690-2 (WBC), ordered on 2026-06-14

Here's the result coming back:

```
MSH|^~\\&|ONTARIOLAB|LAB|OPENEMR|CLINIC|20260614150000||ORU^R01|RES789|D|2.3
PID|1|MRN456||||Smith^Jane||19800101|F
OBR|1|ORD789||6690-2^WBC^LN|||20260614150000|||||||||||F
OBX|1|NM|6690-2^WBC^LN||7.8|x10^9/L|4.0-11.0|N|||F
```

What's different:
- MSH: Message type is ORU^R01 (observation result unsolicited)
- OBX: Now contains the result (7.8 x10^9/L) and status (N = normal)

## Key Takeaway: LOINC Codes in HL7 v2

Notice the pattern: `6690-2^WBC^LN`

This is:
- `6690-2` = LOINC code (the standardized identifier)
- `WBC` = local test name
- `LN` = coding system (LN = LOINC)

This is why LOINC mapping is critical: Mocklab and OpenEMR must both use code `6690-2` to know they're talking about the same test.

## Delimiters

HL7 v2 uses special characters:
- `|` (pipe) = separates fields
- `^` (caret) = separates subfields (like last^first for names)
- `~` (tilde) = separates repetitions
- `\` (backslash) = escape character

You'll see this in every message: `MSH|^~\\&|...`
This tells you: pipe is the field separator, caret is subfield separator, etc.

## What Students Should Know

After this lab, you should be able to:
- Recognize an HL7 v2 message when you see one
- Identify the main segments: MSH, PID, OBR, OBX
- Explain what each segment means
- Understand why LOINC codes matter in HL7 v2 messages
- Recognize that Mocklab generates HL7 v2 messages based on LOINC codes

## Next Step

This foundation helps you understand what Mocklab is doing when it processes orders and generates results. Next, you'll learn how LOINC codes connect test names to standard codes.
