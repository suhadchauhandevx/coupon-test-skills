---
name: coupon-bxgy
description: "Generate an Excel test-case workbook for a BXGY offer (Buy X Get Y free: B1G1, B2G1, same pool / different pool / specific variant, multiplier, coupon-code or auto-apply, combining). Use when the user asks for BXGY, buy one get one, B1G1, buy X get Y, freebie or free-gift-on-purchase test cases for any client project. Test cases only, SBD-style sheet."
trigger: /coupon-bxgy
---

# coupon-bxgy

Run the `coupon-test-core` workflow (`~/.claude/skills/coupon-test-core/SKILL.md`) with the type rules in
`references/type-rules.md`. Read both before writing any case.

Input: the client's requirement for this BXGY offer (text, doc, ticket, screenshot, admin-form description).
Output: `<Project>_BXGY_Buy_X_Get_Y_TestCases.xlsx` in the SBD layout (Cover & Legend, Test Cases, Summary, Mismatches & Open Items).
Default ID prefix: `TC-BXGY-NNN`. Manual test cases only; no automation.
