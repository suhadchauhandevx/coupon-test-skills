# Output format: the SBD-style workbook (manual columns only)

Mirrors `/Users/suhadchauhan/Downloads/SBD_Phase1_TestCases_v2.xlsx` (Arvind x devx labs). The four automation columns of
that file (API Setup, Selectors, API Cleanup, Auto) are intentionally dropped for now. Later versions may add them back.

One workbook per coupon type: `<Project>_<CouponType>_TestCases.xlsx`, saved where the user says (default: the project's
`test-cases/` folder if it exists, else the current directory).

## Sheets
1. **Cover & Legend** — title bar; About this version (Client, Scope, Not covered here, Built from, What changed, Total cases); Column guide; Test-data safety rule (yellow cell); Known behaviours to watch.
2. **Test Cases** — row 1 title bar, row 2 blue header, banner row per section, then case rows. Frozen at B3, autofilter on row 2, dropdowns on Type / Priority / Status.
3. **Summary** — live `COUNTIFS` per section (P, N, E, Total, Critical), TOTAL row, execution-status counts.
4. **Mismatches & Open Items** — `# | Area | Documented / expected | Observed / unknown | Impact & what I need from the team`. All assumptions and undecided rules live here.

## Test Cases columns (11)
`ID | Title | Screen | Route | Type | Priority | Tags | Preconditions | Steps | Expected Result | Status`

| Column | Rule |
|---|---|
| ID | `TC-<PREFIX>-NNN`, zero padded, unique, sequential across the whole workbook (no gaps, no duplicates). Sub-letters (`044a`) only for deliberate variants. |
| Title | Short, specific, states the condition and outcome: "Percent off 101 is rejected". |
| Screen | Section code from `scenario-sections.md` (S-CFG...). |
| Route | Page / flow: `Admin > Store Coupons > Create`, `POS cart`, `Cart > Offers modal`, `Order detail`. Section default can be overridden per case. |
| Type | `P` positive, `N` negative, `E` edge/boundary. |
| Priority | `Critical` (money impact, security, blocker) / `High` / `Medium` / `Low` (cosmetic). |
| Tags | comma list: smoke, sanity, regression, negative, boundary, edge, integrity, rbac, gap-coverage, defect-suspect. Every case has `regression`; add others as fitting. |
| Preconditions | State required before step 1: coupon config, cart contents with real prices, customer, time. Use `—` if none. Show arithmetic: `Cart 333; 10% = 33.3`. |
| Steps | Numbered `1. ...` lines separated by newline. One action per step. |
| Expected Result | ONE outcome that can be judged pass/fail. Include exact amounts, message topic and state changes. Known defect: `KNOWN ISSUE: ... expected to FAIL until fixed.` |
| Status | `Not Run` initially. |

Banner row text: `SECTION NAME  (S-CODE)   —   route   —   N cases`.

## Builder
`scripts/build_xlsx.py` creates the workbook from JSON and validates it. It writes a test-case DOCUMENT only.

Run (venv lives inside this skill; create it if missing):
```
cd ~/.claude/skills/coupon-test-core
[ -d .venv ] || (python3 -m venv .venv && .venv/bin/pip install -q openpyxl)
.venv/bin/python scripts/build_xlsx.py /path/cases.json /path/Output.xlsx
```

JSON schema:
```json
{
  "meta": {
    "project": "Astrotalk", "coupon_type": "Store Coupon: Percentage Discount", "version": "v1.0",
    "client": "...", "scope": "...", "not_covered": "...", "built_from": "...", "what_changed": "...",
    "safety_rule": "Use only TEST_SKU_1_DEVX ... Never place a test order on a real SKU.",
    "notes": [{"label": "Rounding", "text": "...", "warn": true}]
  },
  "sections": [
    {"name": "Configuration validation", "code": "S-CFG", "route": "Admin > Store Coupons > Create",
     "cases": [
       {"id": "TC-PCT-001", "title": "...", "type": "P", "priority": "Critical",
        "tags": "smoke, regression", "pre": "...", "steps": "1. ...\n2. ...", "expected": "...", "route": "optional override"}
     ]}
  ],
  "open_items": [
    {"area": "Cap", "documented": "...", "observed": "...", "impact": "Blocks TC-PCT-040..045; owner: product owner"}
  ]
}
```
Exit code 1 = validation errors (bad Type/Priority, empty field, duplicate ID). Fix and re-run. Warnings (two-outcome
expected results, steps not starting with `1.`) must also be resolved before delivery.

Large files: write the JSON in several section files and merge with a small python snippet, or write cases section by
section into one JSON with the Write tool; do not hand-type the workbook.
