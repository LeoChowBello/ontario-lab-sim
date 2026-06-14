# OpenEMR Database Concepts

## Why You're Learning This

Mocklab doesn't just send HL7 v2 messages—it writes directly into OpenEMR's database. Understanding where the data goes helps you recognize what Mocklab is doing during setup and troubleshoot when something goes wrong.

## Key Tables for Lab Integration

When Mocklab sets up, it inserts records into three main tables:

### 1. procedure_providers

This table defines **who provides lab tests** (the lab organization).

Fields:
- `ppid` — unique provider ID
- `name` — lab name (e.g., "Ontario Reference Lab")
- `npi` — National Provider Identifier
- `active` — whether the provider is active (1 = yes)
- `direction` — B (both), I (inbound), O (outbound)
- `protocol` — "FS" (file-based system)
- `orders_path` — where OpenEMR writes order files for the lab to read
- `results_path` — where the lab writes result files for OpenEMR to read

**Example row:**
```
ppid=5, name="Ontario Reference Lab", npi="123456", active=1, 
protocol="FS", orders_path="/var/www/localhost/htdocs/openemr/sites/default/documents/edi/orders"
```

### 2. procedure_type

This table defines **what tests are available** and which lab provides them.

Fields:
- `procedure_type_id` — unique test ID
- `parent` — links to a parent category (grouping)
- `name` — test name (e.g., "WBC", "Hemoglobin")
- `lab_id` — which lab provides this (links to procedure_providers.ppid)
- `procedure_code` — **the LOINC code** (e.g., "6690-2" for WBC)
- `procedure_type` — "ord" (order) or "fgp" (folder/group)
- `units` — measurement units (e.g., "x10^9/L")
- `range` — normal reference range (e.g., "4.0-11.0")
- `activity` — whether the test is active (1 = yes)

**Example rows:**
```
procedure_type_id=45, name="WBC", lab_id=5, procedure_code="6690-2", 
units="x10^9/L", range="4.0-11.0", activity=1

procedure_type_id=46, name="Hemoglobin", lab_id=5, procedure_code="718-7", 
units="g/L", range="120.0-175.0", activity=1
```

### 3. procedure_order (why this matters)

When a clinician orders a lab test in OpenEMR:
1. A record is created in `procedure_order` with `procedure_type_id` and patient info
2. Mocklab reads which test was ordered (by LOINC code)
3. Mocklab generates a result using that same LOINC code
4. The result matches back to the order

**The match happens via LOINC code**, not by test name.

## How Mocklab Uses This

During setup, Mocklab:

1. **Inserts a provider record** — Creates a row in procedure_providers with name="Ontario Reference Lab", protocol="FS"
2. **Inserts procedure_type records** — One row per test (WBC, Hemoglobin, etc.) with the LOINC code
3. **Sets the file paths** — Tells OpenEMR where to find orders and results

Then during operation:
1. Clinician orders a test → OpenEMR writes an HL7 v2 order file to the `orders_path`
2. Mocklab reads the order file, sees the LOINC code (e.g., 6690-2)
3. Mocklab looks up the test in `procedure_type` by LOINC code
4. Mocklab generates a result with the same LOINC code
5. OpenEMR receives the result and matches it to the original order

## SQL View of the Setup

If you were to inspect the database after Mocklab installs, you'd see:

```sql
SELECT * FROM procedure_providers WHERE name = 'Ontario Reference Lab';
-- Returns one row with ppid, protocol, paths, etc.

SELECT * FROM procedure_type WHERE lab_id = 5;
-- Returns 6+ rows, one per test, with LOINC codes
-- Example: (45, 'WBC', 5, '6690-2', '4.0-11.0', 1)

SELECT * FROM procedure_order WHERE patient_id = 123 AND date_ordered = '2026-06-14';
-- Shows what tests this patient had ordered
-- References procedure_type_id to know which test it is
```

## Key Takeaway

The procedure_type table is **the bridge** between OpenEMR's human-friendly test names and the LOINC codes that Mocklab uses. If the LOINC codes don't match, the system can't connect orders to results.

## What Students Should Know

After this lab, you should understand:
- Where Mocklab stores its configuration (procedure_providers table)
- Where tests are defined (procedure_type table)
- How LOINC codes link everything together
- Why the `orders_path` and `results_path` need to exist
- How clinician orders and lab results are matched in the database

## Next Step

Now that you understand the database structure, you'll learn how order and result files physically flow through the system.
