# Type rules: percentage-off coupon

ID prefix defaults: `TC-PCT-NNN` (single sequence for the whole workbook). Workbook coupon_type: "<Surface> Coupon: Percentage Discount".

## What the type is
`discount = percent x eligible_amount`, optionally limited by `max reduction (cap)`, only when eligibility conditions pass,
within usage limits and validity window, for the configured scope.

## Fields to find in the requirement (else Open Item)
percent range (default assumption 1-100 inclusive; decimals undecided) | cap (optional, blank = none; 0 = ?) | min cart total |
max cart total | min item quantity | inclusivity of boundaries | base of cart total (pre/post tax, pre/post other discounts,
scoped subtotal vs whole cart) | quantity counted over whole cart or scoped items | total usage limit | per-customer limit |
"max uses" if a second overall cap exists | valid from / until + zone | all items vs product vs variant scope | store allocation |
priority | stacking | behaviour on 100% (can order complete at 0?) | rounding rule.

## Section emphasis (beyond scenario-sections.md)
- **S-CFG**: percent boundaries `0 / 1 / 10 / 99.99 / 100 / 101 / 1000 / -5`, blank (placeholder "10" must not be submitted), `abc`, `10%`, `@#`, `1,0`, whitespace, `010`, `12.5`, `0.5`, `100.01`, `1e1`, `1e3`, 20-digit number; API bypass `percent=150`/`0`; edit 10 -> 25 persists and applies to new carts; edit to `0`/`101` rejected.
- **S-MATH**: 10% of 1000 = 100 (payable 900); 100% of 500 = 500 (payable 0); 1% of 999 = 9.99; 10% of 333 = 33.3 (state rounding; check cart = summary = invoice); 3 lines with different prices (sum of rounded line discounts vs rounded total: pick the rule, check drift); qty 3 at 20%; cart of 1 rupee.
- **S-CAP**: cap not reached (10%, cap 500, cart 1000 -> 100); reached (cart 10000 -> 500); exactly at cap; blank cap; cap 0 (open item: rejected vs no discount); negative; text; decimal `99.50`; cap larger than cart (100%, cap 10000, cart 500 -> 500, never negative payable); cap + scope computed on scoped lines only; cap + min cart (ineligible cart -> no discount); cap spread over several scoped lines sums to cap.
- **S-ELIG / S-COMB**: min cart / max cart / min qty boundaries (n-1, n, n+1; 999.99 rejected), then pairs, all three, one-fails-at-a-time, min > max at config rejected, min = max allowed.
- **S-LIMIT, S-DATE, S-SCOPE, S-STACK, S-ORDER, S-ADMIN, S-XCUT**: per `scenario-sections.md`. For percentage specifically: per-line distribution of the percentage with rounding; refund of one line of a mixed cart; cap + partial return.

## Extra bug patterns for this type
- Max discount validated against the percentage value instead of the rupee amount (TC-OFF-BUG-046, 536, 545).
- Percentage applied to MRP instead of discounted price (price-filter / PDP mismatch family).
- 100% discount: savings label missing, free item display, payable 0 order flow.
- Rounding: 50% off qty 2 shows 2400 instead of 2399; B1G2 50% shows 1468 instead of 1469.
- Sub total not reflecting discount.

## Default open items to raise when the requirement is silent
1. Decimals allowed in percent? (blocks S-CFG decimal cases)
2. Cap = 0: rejected or "no discount"?
3. Are min/max cart boundaries inclusive?
4. Base for cart total and for percent: pre- or post-tax, pre- or post-other discounts, scoped or whole cart?
5. Quantity counted over scoped items or whole cart?
6. Total usage limit vs "max uses": relationship (BLOCKER for combined-limit cases).
7. Rounding rule (per line or on total; half-up?).
8. 100% off: can the order complete at payable 0?
9. Edit of an in-use coupon: do open carts re-price?
10. Time zone and inclusive end date.
