---
name: coupon-percentage-discount
description: "Generate an Excel test-case workbook for a PERCENTAGE-OFF coupon (percent off, optional max-discount cap, min/max cart total, min quantity, usage limits, validity dates, product/variant scope). Use when the user asks for percentage coupon / % discount / percent-off / 'X% off' test cases for any client project (Store, POS, web or app). Test cases only, SBD-style sheet."
trigger: /coupon-percentage-discount
---

# coupon-percentage-discount

Run the `coupon-test-core` workflow (`~/.claude/skills/coupon-test-core/SKILL.md`) with the type rules in
`references/type-rules.md`. Read both before writing any case.

Input: the client's requirement for the percentage coupon (text, doc, ticket, screenshot, admin-form description).
Output: `<Project>_Percentage_Discount_TestCases.xlsx` in the SBD layout (Cover & Legend, Test Cases, Summary, Mismatches & Open Items).
Manual test cases only; no automation.
