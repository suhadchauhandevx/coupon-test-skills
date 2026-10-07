---
name: coupon-bxgyaz
description: "Generate an Excel test-case workbook for a BXGYAZ offer (Buy X Get Y at Z% off or fixed price, partial discount on the Y item, different pool / same pool / specific variant, multiplier). Use when the user asks for BXGYAZ, 'buy X get Y at 40% off', 'get second item at half price', or partial-discount-on-get-item test cases for any client project. Test cases only, SBD-style sheet."
trigger: /coupon-bxgyaz
---

# coupon-bxgyaz

Run the `coupon-test-core` workflow (`~/.claude/skills/coupon-test-core/SKILL.md`) with the type rules in
`references/type-rules.md`. Read both before writing any case.

Input: the client's requirement for this BXGYAZ (Buy X, Get Y at partial discount) offer (text, doc, ticket, screenshot, admin-form description).
Output: `<Project>_BXGYAZ_Partial_Discount_TestCases.xlsx` in the SBD layout (Cover & Legend, Test Cases, Summary, Mismatches & Open Items).
Default ID prefix: `TC-BXGYAZ-NNN`. Manual test cases only; no automation.
