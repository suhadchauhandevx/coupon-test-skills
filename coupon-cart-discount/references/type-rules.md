# Type rules: Cart Discount (total / brand / category cart value)

ID prefix default: `TC-CDIS-NNN`. Model reference: FOY `OFFER_COUPON_TEST_CASES.md` Cart Discount sections (core, total, brand,
category, funded-by, edge, negative, UI verification). (FOY) = confirmed on FOY.

## What the type is
A percentage or flat discount on the cart (scope CART) when a minimum cart value is met. Three modes:
- **Total cart value**: `min_cart_value` checked against the whole cart total; discount on the whole cart.
- **Brand cart value**: `min_brand_cart_value` checked against the targeted brand subtotal only; discount only on that brand's lines (FOY).
- **Category cart value**: `min_category_cart_value` against targeted category subtotal; discount only on that category's lines (FOY).
Percentage may have `max_discount` cap. Optional FOY/Brand funding split (sum must equal discount value; server enforced).

## Fields to find in the requirement (else Open Item)
mode | discount type/value | max discount cap | min value (optional or required? TC-OFF-BUG "Min Cart Value Incorrectly Required") |
decimals in min value | boundary inclusive? | brand/category selection (all brands/categories buttons, TC-BUG) | combine with other
offers (the "combine" option needed? TC-OFF-BUG "need confirmation") | funded-by rules | cart visibility | auto-apply or code |
usage limits | validity.

## Section emphasis
- **S-CFG**: percentage and flat value boundaries; max_discount 0 (FOY edge) / below / above / blank; max_discount validated against rupee amount, not the percentage (TC-OFF-BUG-046/536/545); min value optional, decimals (TC-OFF-BUG-047), negative; brand/category required in those modes, helper text; category field must NOT appear inside "Cart Total Value" settings (TC-OFF-BUG "Category Targeting Field Appearing"); funded-by rejected for this type or sums to value; edit form reopens on the saved mode and keeps selected brands/categories when switching tabs (TC-BUG "Cart Discount Edit Form ..."); coupon detail page shows selected brands/categories.
- **S-MATH**: 20% of cart; capped percentage (cap reached / not / exactly); flat; flat above eligible subtotal never negative; multi-line split across eligible lines only; mixed carts (Brand A + Brand B lines) discount only on Brand A; combined brand + category + total offers never push prices below zero (TC-OFF-BUG-057 and "[CRITICAL] Combined Cart Discounts Cause Negative Prices"); brand flat not capped at product price (TC-OFF-BUG-125).
- **S-ELIG**: threshold n-1/n/n+1 for each mode; crossing threshold live both ways auto-applies / auto-removes (FOY: coupon rejected at qty 1, applies at qty 2; offer deactivates when contents drop below minimum in each mode); category total below threshold must not apply (TC-OFF-BUG-048); sub total reflects deduction.
- **S-STACK**: can_be_combined off never stacks (TC-OFF-BUG-056); one-sided combine (TC-OFF-BUG-034); gift offers combined (TC-OFF-BUG "Only One Cart Gift Offer Applied"); gift double-discount (TC-F1 "Cart Gift Coupon Applies Double Discount"); cart-visibility off hidden; applied coupon not listed again.
- **S-ORDER**: discount carries into the order; funding split hidden from shopper (FOY edge); invoice proportional distribution; refund of discounted lines; Admin shows the correct amount (TC-ADMIN-BUG "-Rs 599 instead of -Rs 75").
- **S-LIMIT/S-DATE/S-ADMIN/S-XCUT**: as in scenario-sections.md. Also detail page delete redirect and back button (TC-OFFER-BUG-003/004), long names (TC-OFF-BUG-032).

## Default open items
1. Is the minimum inclusive?
2. Cart value base: before/after other discounts and tax.
3. Brand/category mode when only part of the threshold is in cart.
4. Cart gift behaviour (cart gift is a related offer type: confirm if in scope).
5. Funded-by split visibility and settlement.
