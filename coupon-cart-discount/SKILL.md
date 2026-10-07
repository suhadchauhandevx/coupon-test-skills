---
name: coupon-cart-discount
description: "Generate an Excel test-case workbook for a CART DISCOUNT offer (% or flat off the cart when total / brand / category cart value reaches a minimum, with max discount cap, funded-by split, combine rules). Use when the user asks for cart discount, cart-value offer, 'spend X get Y off', brand-wise or category-wise cart offer test cases for any client project. Test cases only, SBD-style sheet."
trigger: /coupon-cart-discount
---

# coupon-cart-discount

Run the `coupon-test-core` workflow (`~/.claude/skills/coupon-test-core/SKILL.md`) with the type rules in
`references/type-rules.md`. Read both before writing any case.

Input: the client's requirement for this Cart Discount offer (text, doc, ticket, screenshot, admin-form description).
Output: `<Project>_Cart_Discount_TestCases.xlsx` in the SBD layout (Cover & Legend, Test Cases, Summary, Mismatches & Open Items).
Default ID prefix: `TC-CDIS-NNN`. Manual test cases only; no automation.
