---
name: coupon-qty-tiered
description: "Generate an Excel test-case workbook for a QUANTITY-TIERED offer (buy more, save more: 1+ = 40%, 3+ = 50%, flat or percentage tiers, per-product or brand/category scope). Use when the user asks for quantity tier, slab discount, volume discount, 'buy more save more' or tiered pricing test cases for any client project. Test cases only, SBD-style sheet."
trigger: /coupon-qty-tiered
---

# coupon-qty-tiered

Run the `coupon-test-core` workflow (`~/.claude/skills/coupon-test-core/SKILL.md`) with the type rules in
`references/type-rules.md`. Read both before writing any case.

Input: the client's requirement for this Quantity-Tiered offer (text, doc, ticket, screenshot, admin-form description).
Output: `<Project>_Quantity_Tiered_TestCases.xlsx` in the SBD layout (Cover & Legend, Test Cases, Summary, Mismatches & Open Items).
Default ID prefix: `TC-QT-NNN`. Manual test cases only; no automation.
