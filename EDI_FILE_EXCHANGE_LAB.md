# EDI File Exchange

## Why You're Learning This

Mocklab operates using **Electronic Data Interchange (EDI)** — a file-based approach where orders and results are exchanged as text files in directories. This is fundamentally different from API-based integration. Understanding how files flow through the system helps you see how Mocklab operates behind the scenes.

## What Is EDI?

EDI (Electronic Data Interchange) is the exchange of structured data between computer systems through file transfer, not through real-time API calls.

**EDI characteristics:**
- **File-based** — data flows as files in directories
- **Batch processing** — files are processed periodically (not instantly)
- **Asynchronous** — sender and receiver don't have to be connected at the same time
- **Still used in healthcare** — especially for labs and hospital networks

**EDI vs API:**

| Aspect | EDI (Mocklab) | API (Modern FHIR) |
| --- | --- | --- |
| Delivery | Files in directories | HTTP requests |
| Timing | Batch/periodic | Real-time |
| Protocol | HL7 v2 in files | FHIR JSON/XML over HTTP |
| Connection | One-way drops | Two-way conversation |
| Timing Guarantee | No | Yes (HTTP response) |

## How Mocklab's EDI Works

Mocklab uses two directories:

### orders/ Directory (Inbound to Lab)

**Location:** `/var/lib/docker/volumes/openemr_openemr_sites/_data/default/documents/edi/orders`

**What happens:**
1. Clinician orders a lab test in OpenEMR
2. OpenEMR writes an HL7 v2 message to a file in the `orders/` directory
3. Example filename: `ORD_20260614_001.txt`
4. Mocklab reads this file

**File format:**
```
MSH|^~\\&|OPENEMR|CLINIC|ONTARIOLAB|LAB|20260614100000||ORM^O01|MSG001|D|2.3
PID|1|MRN123||||Doe^John||19800101|M
OBR|1|ORD001||6690-2^WBC^LN|||20260614100000
```

### inbox/ (aka results/) Directory (Outbound from Lab)

**Location:** `/var/lib/docker/volumes/openemr_openemr_sites/_data/default/documents/edi/inbox`

**What happens:**
1. Mocklab reads the order file from `orders/`
2. Mocklab generates a result HL7 v2 message
3. Mocklab writes the result to the `inbox/` directory
4. Example filename: `RES_ORD_20260614_001.txt`
5. OpenEMR reads this file and imports the result

**File format:**
```
MSH|^~\\&|ONTARIOLAB|LAB|OPENEMR|CLINIC|20260614150000||ORU^R01|RES001|D|2.3
PID|1|MRN123||||Doe^John||19800101|M
OBR|1|ORD001||6690-2^WBC^LN|||20260614150000|||||||||||F
OBX|1|NM|6690-2^WBC^LN||7.5|x10^9/L|4.0-11.0|N|||F
```

## The EDI Flow (Step by Step)

1. **Clinician orders WBC test**
   - OpenEMR creates procedure_order record
   - OpenEMR writes HL7 v2 order file to `orders/` directory

2. **Mocklab watcher sees the order file**
   - Every 5 seconds, Mocklab scans the `orders/` directory
   - Finds `ORD_20260614_001.txt`
   - Reads the file and extracts LOINC code (6690-2)

3. **Mocklab generates a result**
   - Looks up code 6690-2 in its CATALOG (WBC, units x10^9/L, range 4.0-11.0)
   - Generates a random result between the low/high range
   - Creates a result HL7 v2 message with matching LOINC code

4. **Mocklab writes the result file**
   - Writes result message to `inbox/` directory
   - Filename: `RES_ORD_20260614_001.txt`
   - Deletes the original order file from `orders/`

5. **OpenEMR imports the result**
   - OpenEMR periodically scans `inbox/` directory
   - Reads the result file
   - Matches the result to the original order using LOINC code
   - Creates a result record for the patient

## Key Insight: File Naming Matters

Notice the pattern:
- Order file: `ORD_20260614_001.txt`
- Result file: `RES_ORD_20260614_001.txt`

The naming convention helps track which result corresponds to which order. Both files contain the same LOINC code (6690-2) so they can be matched.

## Advantages and Disadvantages of EDI

**Advantages:**
- Simple file-based approach
- No complex HTTP/API setup needed
- Works across different platforms and networks
- Easy to troubleshoot (files are human-readable text)

**Disadvantages:**
- Not real-time (results come back periodically, not instantly)
- Requires manual file system setup
- No built-in error handling or acknowledgment
- Requires periodic monitoring/polling

## What Students Should Know

After this lab, you should understand:
- How EDI differs from API-based integration
- What the `orders/` and `inbox/` directories are for
- How order files flow into the system
- How result files flow out of the system
- Why file naming and LOINC code matching is critical
- How Mocklab acts as a file watcher between these two directories

## Next Step

Now that you understand the protocol (HL7 v2), the data structure (databases), and the file exchange mechanism (EDI), you'll learn the broader context: why Ontario uses this approach and how it fits into the provincial lab system.
