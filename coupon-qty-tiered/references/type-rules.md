# Type rules: Quantity-Tiered discount

ID prefix default: `TC-QT-NNN`. Model reference: FOY `OFFER_COUPON_TEST_CASES.md` QT sections (core, percentage, flat-mixed,
narrowing, negative, boundary-summary, combined, scope, UI verification). (FOY) = confirmed on FOY.

## What the type is
A list of tiers `{min_qty, discount_value, discount_type}`; the highest tier whose `min_qty` is met applies to the
qualifying quantity (FOY: independent of array order). PERCENTAGE tier = pct% off each qualifying item's own price. FLAT tier
value is a TOTAL for the whole qualifying pool, capped at pool total, split proportionally across lines, not per unit (FOY).
`allow_multiplier` has no observable effect (FOY).

## Fields to find in the requirement (else Open Item)
tier list (min_qty, value, type) | is tier quantity per product or per pool (all qualifying lines together) | tier discount on all
units or only units above the threshold | percentage vs flat vs mixed tiers | scope (brand/category/variant, narrowing) |
overlapping or equal min_qty tiers | cap | coupon or auto-apply | combining | decimals in prices (rounded whole rupees? TC-OFF-BUG-049) |
whole-rupee rounding rule.

## Section emphasis
- **S-CFG**: tier min_qty 0/1/negative/decimal/duplicate/unsorted; discount 0/100/101/negative; no tiers; one tier; many tiers; flat larger than pool total; mixed types in one offer; edit tiers then reopen shows saved tiers; helper text; tier overlap validation.
- **S-MATH**: percentage tiers at each boundary (qty = tier-1, = tier, = tier+1) with real prices (savings = round(price x qty x pct)); upgrade 1 -> 3 and downgrade 3 -> 2 via line-item updates; flat tier total shared proportionally across 2-3 lines; flat >= pool total capped; mixed tiers selection; rounding to whole rupees, no decimal prices in cart (TC-OFF-BUG-049); qty change recalculates live; very large qty.
- **S-SCOPE**: brand, category, variant and combinations; narrowing (IDs within a field OR, different fields AND, FOY); qualifying quantity counted across lines of the same scope; non-qualifying item in the same cart gets nothing; partial scope match.
- **S-STACK**: two tiered offers on the same SKU: best applies, not both (TC-OFF-BUG-058, TC-OFF-BUG "Multiple Auto-Applied QT Offers Not Applying Best Offer Per Product"); Combined OFF/ON; QT + BXGY/BXAY/BXGYAZ/cart discount; best = higher tier percentage (FOY); coins interplay.
- **S-ORDER**: applied-offers breakdown per product; order metadata; return of units that drop the order below a tier (refund price? BLOCKER open item); PDP tier table display.
- **S-LIMIT/S-DATE/S-ADMIN/S-XCUT**: as in scenario-sections.md.

## Default open items
1. Tier applies to all units or only the excess?
2. Return that crosses below a tier: re-price the remaining units?
3. Tier counting across variants of one product.
4. Rounding rule.
5. Stacking order with other discounts.
