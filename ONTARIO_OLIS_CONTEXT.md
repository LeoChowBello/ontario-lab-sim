# Ontario OLIS Context

## Why You're Learning This

Mocklab simulates **Ontario OLIS** (Ontario Laboratories Information System), the real provincial lab communication standard used across Ontario. Understanding why Ontario uses HL7 v2 and EDI helps you see why this curriculum focuses on these older but still-critical technologies.

## What Is OLIS?

**OLIS** = Ontario Laboratories Information System

OLIS is Ontario's provincial standard for how:
- Hospital labs communicate with lab ordering systems (like OpenEMR)
- Reference labs send results back to hospitals
- Laboratory data flows across the healthcare system

## Why OLIS Uses HL7 v2

Ontario's healthcare system evolved over decades. When OLIS was designed in the 1990s:
- HL7 v2 was the only widely-adopted healthcare messaging standard
- The internet was not yet common for healthcare data
- File-based EDI was the standard way systems communicated
- HL7 v2 is still supported by hospital labs and government systems today

**Today:**
- Newer systems use FHIR (modern API-based approach)
- But legacy systems still use HL7 v2
- Ontario hasn't fully migrated to FHIR
- Many hospitals still have labs running on systems that only speak HL7 v2
- If your EMR (like OpenEMR or OSCAR) needs to talk to a real Ontario lab, you must use HL7 v2

## The Ontario Lab Network

Simplified view of how Ontario labs connect:

```
Community Clinic (OpenEMR)
        ↓
    [Orders via EDI/HL7 v2]
        ↓
    OLIS Router
        ↓
    [Routes to appropriate lab]
        ↓
Hospital Lab / Reference Lab
        ↓
    [Results via EDI/HL7 v2]
        ↓
Community Clinic (receives results)
```

Key points:
- **Orders go OUT** using HL7 v2 files (EDI)
- **Results come BACK** using HL7 v2 files (EDI)
- **LOINC codes** ensure both systems agree on what test was ordered
- **Timing is asynchronous** — results might come back hours or days later

## Real-World Example: Ordering a CBC

1. **Clinic (OpenEMR):** Clinician orders a CBC (Complete Blood Count)
   - OpenEMR looks up CBC in its procedure_type table
   - Finds LOINC code group for CBC tests
   - Writes HL7 v2 order file with LOINC codes to the EDI directory

2. **OLIS Router receives the order**
   - Reads the HL7 v2 message
   - Identifies the patient and test codes
   - Routes the order to the correct lab (based on clinic location/lab contract)

3. **Reference Lab receives the order**
   - Lab's analyzer (automated equipment) processes the request
   - Equipment runs the test and generates results with standard LOINC codes
   - Lab system formats results as HL7 v2 message and sends back via EDI

4. **Clinic (OpenEMR) receives the result**
   - Reads the HL7 v2 result file from EDI
   - Matches result LOINC codes to the original order
   - Stores results in patient's chart
   - Clinician sees "WBC: 7.2 x10^9/L (Normal)"

## Why This Matters for Informatics

As an informatics professional in Ontario, you need to understand:

1. **OLIS is not optional** — If you work with hospital labs in Ontario, you WILL encounter HL7 v2 and OLIS standards

2. **LOINC codes are critical** — They're the standardization layer that makes the whole system work. Without matching LOINC codes, orders don't match results.

3. **EDI is still operational** — Even as newer systems adopt FHIR, many labs still use EDI. Understanding both is valuable.

4. **Legacy systems are everywhere** — Ontario's healthcare infrastructure has systems running for 20+ years. Understanding older protocols helps you maintain and extend those systems.

5. **Mocklab simulates real behavior** — The way Mocklab works mirrors how actual OLIS-connected labs operate. Learning Mocklab teaches you how the real system works.

## The Evolution: Why FHIR Comes Later

**Stage 1-2 (This curriculum):** HL7 v2 via EDI
- How Ontario OLIS works today
- What existing hospital labs use
- Foundation for understanding lab integration

**Stage 3 (Future):** FHIR API
- How modern healthcare systems integrate
- What new systems will use
- Still not universal in Ontario yet

Both approaches coexist in Ontario healthcare. Understanding both makes you valuable to healthcare organizations.

## What Students Should Know

After this lab, you should understand:
- What OLIS is and why it matters in Ontario
- Why Ontario still uses HL7 v2 despite newer standards
- How real lab ordering and results work in Ontario
- Why Mocklab is a realistic simulation of actual OLIS behavior
- Why LOINC codes are the foundation of the entire system
- How informatics professionals interact with OLIS in their work

## Connecting the Pieces

Now you've learned:

1. **HL7 v2 Basics** — How messages are structured (segments, delimiters)
2. **LOINC Code Mapping** — How test names are standardized to codes
3. **Database Concepts** — Where OpenEMR stores lab configuration
4. **EDI File Exchange** — How orders and results flow through directories
5. **Ontario OLIS Context** — Why all of this exists in Ontario

These five pieces together explain how Mocklab works and why it matters.

## Next Step

You're now ready for Stage 2: Setting up Mocklab and seeing these concepts in action.
