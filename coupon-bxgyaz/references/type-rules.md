# Type rules: BXGYAZ (Buy X, Get Y at Z% off / fixed final price)

ID prefix default: `TC-BXGYAZ-NNN`. Model reference: FOY `OFFER_COUPON_TEST_CASES.md` BXGYAZ sections (core, same-pool, diff-pool,
specific-variant, multiplier, lifecycle, price-summary, combined, combined-subtypes, cross-type). (FOY) = confirmed on FOY.

## What the type is
Like BXGY but the Get item (Z) is discounted partially instead of free: PERCENTAGE (e.g. 40% off Z) or FLAT = Z's final
price set to the value (savings = price - value) (FOY). X is never discounted (FOY). Z `is_free` false.

## Variants
- **Same pool**: Z is the cheapest qualifying unit of the same pool (`allow_same_sku` true).
- **Different pool**: X and Z scoped independently; both must be in cart; "Open Z" (empty Z scope): any non-X item qualifies.
- **Specific variant (mandatory Z)**: one exact Z variant must be in cart with X.

## Fields to find in the requirement (else Open Item)
discount type and value for Z (percent range, flat final price) | min_quantity (X) | get_y_quantity | which unit is Z in same pool |
multiplier rule (one Z per qualifying X, capped at min(X count, Z count), FOY) | scope for X and Z | Z OOS handling | stacking with
other offers | cap on Z discount | flat value above Z price | rounding.

## Section emphasis
- **S-CFG**: percent 0/1/100/101/negative/decimal; flat value 0 / above Z price / negative; empty Z scope; get_y_quantity > Z available; "Get Y Discount Method" field shown only when relevant.
- **S-MATH**: 40% of Z price 2150 -> savings 860, X unchanged (compute with real prices); flat final price 500 on Z 2150 -> savings 1650; flat above Z price (no negative discount); percentage rounding Math.round(price x count x pct); multiplier OFF -> one Z discounted regardless of qty; ON -> count = min(X count, Z count); Z qty change recalculates; remove and re-add Z; cart price summary arithmetic (MRP, discount label, sub total, payable); X never discounted even when X is also in Z scope.
- **S-SCOPE**: X scope and Z scope each by brand/category/variant; both required; X only / Z only / neither -> no offer; Z = same SKU as X rules; Z OOS mid-session (offer drops with message); Z removed mid-session; precedence variant > brand > category on overlap.
- **S-STACK**: BXGYAZ + BXGYAZ of different sub-types, + BXAY, + BXGY, + Quantity-Tiered, Combined OFF/ON, contradiction -> exactly one; best by actual savings; auto-apply visibility; coupon + auto-apply (TC-OFF-BUG-044).
- **S-ORDER**: partial-discount Z in order detail and invoice with correct tax base; return of Z refunds discounted price; return of X when Z discount depended on X (BLOCKER open item); price summary labels (TC-BUG "Discount Percentage Missing").
- **S-LIMIT/S-DATE/S-ADMIN/S-XCUT**: as in scenario-sections.md.

## Default open items
1. Return of X after Z shipped at discount.
2. Flat meaning: final price vs amount off.
3. Which unit is Z when several qualify.
4. Max discount cap on Z.
5. Rounding rule.
