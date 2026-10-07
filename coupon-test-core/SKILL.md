---
name: coupon-test-core
description: "Shared engine for coupon/offer test-case generation. Use when the user asks for test cases for ANY coupon, discount code, offer or promotion (percentage, flat, BXGY, BXAY, quantity-tiered, cart discount, code apply/remove) and no more specific coupon-* skill applies, or when they say 'coupon test cases', 'offer test cases', 'discount test cases'. Reads the client's coupon requirement, records open questions, and writes an SBD-style Excel workbook (Cover, Test Cases, Summary, Open Items) of manual test cases covering config validation, math, eligibility, usage limits, validity (IST), scope, stacking, order lifecycle and cross-cutting cases. Test cases only; no automation."
trigger: /coupon-tests
---

# coupon-test-core

Produces a **manual test-case workbook (.xlsx)** for a coupon/offer, in the layout of the SBD reference sheet.
Test cases only. Do not generate Playwright/API automation, selectors or scripts for the tests.
The type skills (`coupon-percentage-discount`, `coupon-flat-discount`, `coupon-code-basic`, `coupon-bxgy`, `coupon-bxay`,
`coupon-bxgyaz`, `coupon-qty-tiered`, `coupon-cart-discount`) call this workflow with their own type rules.

## Usage
```
/coupon-tests                       # asks which coupon type, then runs the workflow
/coupon-tests <requirement text or file path>
/coupon-percentage-discount <requirement>      # (and the other type skills)
```

## Workflow

1. **Load references** (read, do not skim): `references/intake-questionnaire.md`, `references/scenario-sections.md`,
   `references/bug-patterns.md`, `references/sheet-format.md`, `references/self-review-checklist.md`.
   If invoked through a type skill, also read that skill's `references/type-rules.md`.
2. **Intake.** Read the client requirement the user gave (text, file, screenshot, ticket). If a repo `CLAUDE.md`, README or
   earlier test-case file exists in the working directory, read it for project facts (time zone, test SKUs, tax, ID prefix).
   Fill the coupon spec table from `intake-questionnaire.md`. Mark every unknown `?`.
3. **Open items.** Turn each unknown that changes an expected result into an Open Item row (area, what is unclear, who
   confirms, which cases depend on it). Ask the user the critical ones in ONE batched question (max 8). If the user is in
   auto mode or has said to proceed, continue with explicit assumptions listed as Open Items. Never invent client rules.
4. **Restate.** Show a short summary: coupon spec, open items, sections included/skipped, estimated case counts. Continue
   without waiting unless a blocker prevents writing any meaningful expected result.
5. **Write cases** section by section into a JSON file following the schema in `references/sheet-format.md`
   (put it in the scratchpad or `/tmp`-style temp dir, not in the user's repo). Rules:
   - Expand every applicable section of `scenario-sections.md`; the type skill's `type-rules.md` adds type-specific sections.
   - Boundaries n-1 / n / n+1; recompute every number; show arithmetic in Preconditions.
   - One expected result per case. Unknown rule => Open Item + Status `Query`, not "either/or".
   - Weave in the patterns of `bug-patterns.md`; cite the ticket (e.g. `regression of TC-OFF-BUG-059`) in Preconditions or Title.
   - Use the project's approved test data; print its safety rule on the Cover (`meta.safety_rule`).
6. **Build.** Run the builder (venv is inside this skill):
   ```
   cd ~/.claude/skills/coupon-test-core
   [ -d .venv ] || (python3 -m venv .venv && .venv/bin/pip install -q openpyxl)
   .venv/bin/python scripts/build_xlsx.py <cases.json> <Project>_<CouponType>_TestCases.xlsx
   ```
   Fix every ERROR and WARN it prints, then re-run.
7. **Self-review** with `references/self-review-checklist.md`. Fix gaps.
8. **Report** briefly: output path, counts by Type and Priority, number of Open Items and which are blockers, sections skipped.

## Rules
- Test cases only. No automation columns (API setup, selectors, cleanup, auto flag) for now; do not offer them unless asked.
- Never fabricate client behaviour, prices, SKUs or IDs. Missing => placeholder + Open Item.
- Respect any test-data safety rule (for example "approved test SKUs only"); never write a step that violates it.
- Do not edit the user's existing test-case files; write a new workbook. Do not commit or push.
- Time-zone logic: IST is UTC+05:30 and is ahead of UTC. Discriminating cases are 00:00-05:30 local on the start date and
  05:30-23:59 local on the end date.
- Keep the final chat message short: counts and open items, no restating the cases.

## Extending
New coupon type = new thin skill folder `coupon-<type>/` with `SKILL.md` (trigger, one-paragraph description, "read
coupon-test-core and run its workflow with these type rules") and `references/type-rules.md` (type-specific rules,
extra sections, extra bug patterns). New scenario classes that apply to all types go into `references/scenario-sections.md`.
