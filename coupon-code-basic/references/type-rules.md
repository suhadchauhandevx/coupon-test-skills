# Type rules: coupon-code apply / remove flow

ID prefix default: `TC-CODE-NNN`. Workbook coupon_type: "Coupon Code: Apply, Remove & Validation".
Model reference: FOY `COUPON_TEST_CASES.md` (COUP-001..015 API, TC-CART2-012..023 UI, 030, 037) and its test-data table
(valid / invalid / expired / min-order / category coupons).

## What the flow is
A shopper (or cashier) types a code or taps Apply on a listed coupon; the system validates (exists, active, dates, cart
eligibility, limits), shows success or a specific error, updates the price summary, and lets the shopper remove the coupon.

## Sections (use scenario-sections.md codes; this type leans on S-XCUT, S-ELIG, S-STACK, S-LIMIT, S-DATE, S-ADMIN)
**Get/list available coupons** - cart with items, empty cart, non-existent cart ID, coupon already applied shows Remove not Apply (TC-OFF-BUG-038), cart-visibility off hidden, expired/paused/deleted hidden, ineligible coupons shown with reason or hidden (open item), list order, per-coupon description length limits (TC-UI-BUG "Coupon Description Has No Length Limit").
**Apply by typing** - valid code -> chip/applied state + total drops + discount line in summary; invalid code -> specific error, price unchanged; expired -> expiry error; not yet started; usage exhausted (apply-time vs checkout-time behaviour is an open item; FOY backend enforces only at checkout); below minimum -> "minimum" message; category/brand/scope mismatch -> "not applicable"; empty field (button disabled or "enter a code"); whitespace only; leading/trailing spaces trimmed; lower/upper case; special characters; very long string; emoji; SQL/HTML injection strings return a clean error; code of a paused offer returns the same generic error as an unknown code (enumeration, GAP-1).
**Apply from list / panel** - View All opens panel; apply from list applies the same code; type inside panel; applied state shows Remove and success confirmation (TC-CART-UI-BUG "Coupon Applied state not implemented"); sticky input on mobile; keyboard overlap.
**Remove** - remove applied coupon reverts total to the exact pre-coupon amount; remove when none applied (rejected); remove with a different code (rejected); remove then re-apply (applies again or "already used" per rule); remove one of several; remove after the cart changed.
**Second coupon / stacking** - apply second code over first (replaced or rejected per rule), correct discount shown immediately not only after refresh (TC-BUG "Incorrect Discount Amount After Second Coupon"), combinable pair keeps both (TC-OFF-BUG-033/037), non-combinable never stacks (TC-OFF-BUG-056), coupon + FOY coins/wallet.
**Cart state** - empty cart; cart below minimum then item added; item removed after apply -> coupon removed or invalidated; qty change re-evaluates (TC-OFF-BUG-059); cart changed in another tab; guest cart merged on login keeps/drops coupon (open item); session expiry clears coupon.
**Persistence** - refresh, back/forward, reopen cart next day (revalidated), order placed with coupon -> order detail and invoice show it; coupon in applied-offers breakdown with correct name and savings (TC-CART-BUG-001/002).
**API-level (manual, via REST client)** - apply without auth, to someone else's cart, with missing/empty `code`, with extra fields, malformed JSON; list coupons for unknown cart; responses carry no stack trace / SQL (TC-ACC-BUG-103).
**Admin link** - coupon created in admin appears in the shopper list; deactivated disappears; editing code/value updates carts at next load.

## Test data (ask; do not invent)
valid coupon (code, discount, min cart) | second valid coupon | invalid code | expired coupon | min-order coupon | category/brand-restricted coupon | usage-exhausted coupon | cart contents with prices.

## Default open items
1. Usage-limit enforcement at apply time or checkout only?
2. Second coupon: replace or reject?
3. Can a removed coupon be re-applied (once-per-customer rule)?
4. Are ineligible coupons shown in the list, and with what reason text?
5. Case sensitivity and trimming of codes.
6. Guest cart + login: coupon kept?
