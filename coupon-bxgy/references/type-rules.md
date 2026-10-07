# Type rules: BXGY (Buy X, Get Y free)

ID prefix default: `TC-BXGY-NNN`. Model reference: FOY `OFFER_COUPON_TEST_CASES.md` BXGY sections (same-pool, diff-pool,
specific-target, multiplier, lifecycle, price-summary, combined, cross-type combos, UI verification). FOY-confirmed behaviours
below are labelled (FOY); verify against the client's engine and raise an Open Item when different or unknown.

## What the type is
When the cart contains >= `min_quantity` units of the Buy pool X, `get_y_quantity` units of Y are free (discount = Y unit
price, line total 0, `is_free`). Offer applies via coupon code or auto-apply.

## Variants (each is its own section)
- **Same pool**: Y comes from the same pool as X; the cheapest qualifying unit is free (FOY). `allow_same_sku` true lets the same SKU supply X and Y (B1G1 on 2 units of one SKU).
- **Different pool**: X and Y are different sets (X by brand/category/variant; Y by brand/category/variant). Both must be in cart. "Open Y" (no Y scope): any non-X item can be free (FOY). Y also present in the buy pool: must not trigger incorrectly (TC-OFF-BUG-030).
- **Specific variant**: one mandatory exact Y variant must be in the cart with an X item; look-alike items do not qualify; auto-apply must add or require the Y item, not apply with no free item (TC-OFF-BUG-031, TC-OFFER-BUG-008).

## Fields to find in the requirement (else Open Item)
min_quantity (X) | get_y_quantity | pool definitions and scope type (brand/category/variant) | allow_multiplier | allow_same_sku |
free item chosen by (cheapest? customer? fixed?) | Y out of stock behaviour | auto-apply or code | can_be_combined / priority |
usage limits | validity | cart visibility | PDP badge | what the customer sees (Free tag, savings line) | return/refund rule for a free item.

## Section emphasis
- **S-CFG**: min_quantity / get_y_quantity boundaries (0, 1, large, negative, decimal), empty pools, Y scope = X scope, both quantities set to extremes; admin accepts min_quantity 0 server-side (FOY gap); "Include bonus gift" toggle lets you select the gift variant (TC-OFF-BUG-036); irrelevant fields hidden (TC-OFF-BUG-035 "Get Y Discount Method" shown wrongly).
- **S-MATH**: B1G1 on 2 units -> cheaper unit free; B1G1 with 3 units and multiplier OFF -> one free; multiplier ON -> floor(qty/2) free (FOY: expected = floor); B2G1; X present but Y price higher/lower; discount = Y unit price exactly; total savings and price summary rows consistent (Total MRP, discount, sub total, payable).
- **S-ELIG**: below threshold (n-1) rejected with message; at threshold; above; qty increase/decrease re-evaluates the free quantity live; remove X after apply removes the free item (TC-BXGY lifecycle); bundle config changed in admin applies to new quantity changes consistently (TC-OFF-BUG "B1G1 to B1G2 applied immediately without refresh").
- **S-SCOPE**: brand/category/variant X scopes, multi-target narrowing (IDs within a field are OR'd, different fields AND'd, FOY); non-qualifying items; precedence variant > brand > category when scopes overlap (FOY); Y OOS; Y added after coupon applied.
- **S-STACK**: Combined OFF: one best offer fires; Combined ON + paired: both fire when scopes do not contradict; contradiction -> exactly one fires (FOY); BXGY + BXAY, + BXGYAZ, + Quantity-Tiered, + cart discount, + coins; auto-apply vs coupon; best offer by actual savings, re-evaluated on every cart change (TC-BUG "Auto-Apply Offer Not Re-Evaluated on Quantity Change", TC-OFF-BUG-039/043/052/053/054, TC-OFFER-BUG-007/009).
- **S-ORDER**: free item in order detail, invoice (price 0 or allocated?), admin order, WMS sync with correct SKUs (TC-BUG "WMS Receiving Incorrect Line Items"), cart badge excludes free items (TC-OFF-BUG-154), "Go to Bag" vs "Add to Bag" for an item that is free in cart, return of free item, return of paid X leaves Y?, coins on free item, stock deduction for free units once (TC-INV-BUG double deduction).
- **S-XCUT/UI**: Free badge, applied-offers breakdown (paid qty X2 not X1, TC-CART-BUG-002), free item tap goes to PDP (TC-BUG), free item at end of list, replace/OOS popup quantities, inconsistent apply across browser sessions (TC-BUG "BXGY Auto-Apply Inconsistently Applied Across Sessions").

## Default open items
1. Which unit is free in same pool (cheapest, last added, customer choice)?
2. Multiplier: floor(qty / (X+Y)) or floor(qty/X)?
3. Is Y auto-added to cart when missing (specific variant) or must the customer add it?
4. Return of X after free Y shipped; return of free item.
5. Tax invoice treatment of free items.
6. Priority/tie-break when two BXGY offers are equally valuable.
7. Y out of stock: offer skipped or blocked?
