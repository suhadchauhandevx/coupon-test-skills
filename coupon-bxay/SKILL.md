---
name: coupon-bxay
description: "Generate an Excel test-case workbook for a BXAY offer (Buy X units for a fixed bundle price / buy 2 for Rs 1000, batch pricing with remainder at full price, multiplier). Use when the user asks for BXAY, bundle price, 'buy N for Rs X', combo price or batch-price offer test cases for any client project. Test cases only, SBD-style sheet."
trigger: /coupon-bxay
---

# coupon-bxay

Run the `coupon-test-core` workflow (`~/.claude/skills/coupon-test-core/SKILL.md`) with the type rules in
`references/type-rules.md`. Read both before writing any case.

Input: the client's requirement for this BXAY (bundle price) offer (text, doc, ticket, screenshot, admin-form description).
Output: `<Project>_BXAY_Bundle_Price_TestCases.xlsx` in the SBD layout (Cover & Legend, Test Cases, Summary, Mismatches & Open Items).
Default ID prefix: `TC-BXAY-NNN`. Manual test cases only; no automation.
