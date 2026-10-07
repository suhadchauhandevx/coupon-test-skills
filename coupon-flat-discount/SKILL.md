---
name: coupon-flat-discount
description: "Generate an Excel test-case workbook for a FLAT-AMOUNT-OFF coupon (fixed rupee/currency amount off, e.g. FLAT75OFF; min/max cart total, min quantity, usage limits, validity dates, product/variant scope, split across lines, never negative). Use when the user asks for flat discount / flat off / fixed amount coupon / 'Rs X off' test cases for any client project. Test cases only, SBD-style sheet."
trigger: /coupon-flat-discount
---

# coupon-flat-discount

Run the `coupon-test-core` workflow (`~/.claude/skills/coupon-test-core/SKILL.md`) with the type rules in
`references/type-rules.md`. Read both before writing any case.

Input: the client's requirement for the flat coupon (text, doc, ticket, screenshot, admin-form description).
Output: `<Project>_Flat_Discount_TestCases.xlsx` in the SBD layout. Manual test cases only; no automation.
