# Type rules: flat-amount coupon

ID prefix default: `TC-FLT-NNN`. Workbook coupon_type: "<Surface> Coupon: Flat Discount".

## What the type is
`discount = min(flat_amount, eligible_amount)` when eligibility passes, within usage limits and validity, for the configured
scope. The discount is a total for the cart (or scoped lines) and must be split across lines when per-line display or
refund needs it.

## Fields to find in the requirement (else Open Item)
flat amount and allowed range (min > 0? decimals? upper bound?) | currency/rounding | min cart total | max cart total |
min item quantity | boundary inclusivity | base of cart total | what happens when flat > eligible amount (cap at eligible
amount? reject coupon?) | split rule across lines (proportional to line value? first line?) | scope | per-line discount stored
for returns | usage limits | validity | stacking | funding split (platform + brand = flat amount?) | free-shipping or COD fee interplay.

## Section emphasis (beyond scenario-sections.md)
- **S-CFG**: amount `0 / 0.01 / 1 / 75 / large 9999999 / -75`, blank, text, special chars, decimals `75.5`, `75.555`, leading zeros, exponent, very long; API bypass with `-75`/`0`; edit persists; helper text matches behaviour; amount larger than any possible cart (allowed? warning?).
- **S-MATH**: flat 75 on cart 1000 -> 925; flat = cart total -> payable 0; flat > cart (cart 50, flat 75 -> discount 50 or reject: Open Item) never negative payable; flat > single item price in a multi-item cart (item must not go negative: bug TC-OFF-BUG "Cart Crashes with Raw SQL DB Error When Product Flat Discount Exceeds Price"); two lines split proportionally and sum exactly (rounding remainder rule); qty 3 of one item; cart quantity change after apply recomputes; discount never greater than eligible amount; no 300%+ discount percentage shown on PLP/cart (TC-BUG "Flat Product Discount Exceeding MRP").
- **S-CAP**: flat vs eligible amount comparisons (below / equal / above), scoped lines smaller than the flat amount, flat + min cart interplay, flat funded by brand + platform: parts add up to the flat value (server enforces), funded-by not allowed for a type that does not support it.
- **S-ELIG / S-COMB / S-LIMIT / S-DATE / S-SCOPE / S-STACK / S-ORDER / S-ADMIN / S-XCUT**: per `scenario-sections.md`. For flat specifically: refund of one line gets its share of the flat amount; partial return when flat was split; refund total across all lines equals flat amount; second coupon replacing a flat coupon; combined flats never drive total below zero (TC-OFF-BUG-057, "[CRITICAL] Combined Cart Discounts Cause Negative Item Prices").

## Extra bug patterns for this type
- Flat discount exceeding price: negative item price, raw SQL error, 300%+ discount percent.
- Max-discount field wrongly applied to flat type (TC-OFF-BUG-046 family: validation compared against percentage).
- Flat limit shown as "-Rs 599" B1G1 amount instead of "-Rs 75" in admin applied offers (TC-ADMIN-BUG "Flat 75 Off Shows -599").
- Discount not deducted from Sub Total.
- Manual coupon FLAT75OFF shown as "Auto-applied" in admin.

## Default open items to raise when the requirement is silent
1. Flat amount greater than eligible amount: capped or rejected?
2. Split rule across lines and rounding remainder.
3. Boundaries inclusive? Base of cart total (pre/post tax, pre/post other discounts)?
4. Decimals allowed in the amount? Upper bound?
5. Refund rule for partial returns of a flat-discounted order.
6. Usage-limit semantics (total vs max uses) and when a use is counted.
7. Stacking with other coupons/auto offers/wallet.
8. Time zone and inclusive end date.
9. Funding split (platform vs brand) applicable?
