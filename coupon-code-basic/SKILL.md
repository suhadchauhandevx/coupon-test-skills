---
name: coupon-code-basic
description: "Generate an Excel test-case workbook for the basic coupon-CODE flow: apply a typed code, apply from the offers list, remove, re-apply, invalid, expired, empty, wrong-case, spaces, duplicate/second coupon, empty or ineligible cart, and the API/UI responses for each. Use when the user asks for coupon code apply/remove test cases, 'coupon field', 'promo code', or 'voucher' test cases for any client project. Test cases only, SBD-style sheet."
trigger: /coupon-code-basic
---

# coupon-code-basic

Run the `coupon-test-core` workflow (`~/.claude/skills/coupon-test-core/SKILL.md`) with the type rules in
`references/type-rules.md`. Read both before writing any case.

Input: the client's requirement for this coupon-code (apply/remove) flow (text, doc, ticket, screenshot, admin-form description).
Output: `<Project>_Coupon_Code_Apply_Remove_TestCases.xlsx` in the SBD layout (Cover & Legend, Test Cases, Summary, Mismatches & Open Items).
Default ID prefix: `TC-CODE-NNN`. Manual test cases only; no automation.
