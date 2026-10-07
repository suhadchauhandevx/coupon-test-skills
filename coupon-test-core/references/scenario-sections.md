# Scenario sections (the coverage spine)

Every coupon-type skill expands this list for its own type. A section is skipped ONLY when it genuinely does not apply
to that type, and the skip is stated in the Cover sheet "Not covered here" line. Each bullet below is a case *family*;
expand each into concrete cases with real numbers. Boundaries are always n-1, n, n+1.

Section codes (use as the `Screen` column and in case IDs):

| # | Name | Code | Typical route |
|---|---|---|---|
| 1 | Configuration validation | S-CFG | Admin > create/edit coupon |
| 2 | Discount math | S-MATH | Cart / checkout |
| 3 | Cap / value limits | S-CAP | Cart + Admin |
| 4 | Eligibility: single condition | S-ELIG | Cart |
| 5 | Eligibility: combinations | S-COMB | Cart |
| 6 | Usage limits | S-LIMIT | Cart + Checkout + Admin |
| 7 | Validity window | S-DATE | Admin + Cart |
| 8 | Scope, distribution, sequences | S-SCOPE | Cart |
| 9 | Stacking and combining | S-STACK | Cart |
| 10 | Order lifecycle and money trail | S-ORDER | Order, Invoice, Returns |
| 11 | Admin form and data integrity | S-ADMIN | Admin |
| 12 | Cross-cutting and UI | S-XCUT | All |

---
## 1. Configuration validation (S-CFG)
Applies to every numeric/text field of the coupon form (value, cap, min/max cart, min qty, limits, code, name).
- Boundaries of each numeric field: below min, min, mid, max, above max (e.g. percent 0 / 1 / 10 / 100 / 101; far above 1000).
- Negative, zero, blank/required (placeholder text must not be submitted as a value), whitespace only.
- Non-numeric text, special characters (`10%`, `@#`, `1,0`), leading zeros (`010`), decimals within and at boundaries (`12.5`, `0.5`, `100.01`, `99.99`), exponent (`1e1`, `1e3`), very long number (no 500).
- Spinner/arrow keys and mouse-wheel on number input stay in range.
- Bypass UI validation via API/DevTools (`150`, `0`, `-5`): server must reject with a 4xx and clear message.
- Edit existing coupon: valid change persists; invalid change rejected as on create; new carts use the new value; open carts behave as the business decided (open item if undecided).
- Coupon code field: min/max length, case, spaces, special chars, unicode, SQL/HTML injection strings, duplicate code, name field max length (FOY bug: no input validation on coupon name).
- Mandatory-field matrix: leave each required field blank in turn (FOY bug: missing required-field validation on creation).
- Helper text must match behaviour (FOY bug: "leave empty to include all" contradicted mandatory validation).
- Max-discount vs value comparison is correct per type (FOY bug: max discount wrongly compared with percentage value; min cart wrongly required > 0 when optional).
- Decimal values in rupee fields (min cart `999.50`) accepted or rejected consistently.

## 2. Discount math (S-MATH)
Use real numbers; show the arithmetic in Preconditions/Steps when not obvious.
- Round amounts (10% of 1000), 1% and 100% off, fractional results (333 x 10% = 33.3): state the rounding rule, check no 1-rupee/1-paise drift between cart, order summary, invoice, admin (FOY bugs: 2400 vs 2399, 1468 vs 1469).
- Multi-line cart: total discount equals the sum of per-line discounts; invoice line breakdown sums to total.
- Quantity > 1: discount on line total (price x qty); change qty up/down and re-check.
- Very small cart (1 rupee), very large cart (100 lines), large quantity.
- Never negative payable, never discount > eligible amount (FOY critical bugs: negative item price and cart crash with raw SQL error when flat discount exceeds price; 300%+ discount percent shown on PLP).
- 100% off: payable 0, order can complete or behaviour defined; discount label still shown (FOY bug: savings label missing at 100%).
- Discount computed on MRP vs on already-discounted (offer) price: state the base and test both.
- Sub Total row actually reflects the deduction (FOY bug: sub total not reflecting discount).

## 3. Cap / value limits (S-CAP)
- Percentage: cap not reached / exactly at cap / exceeded / blank (no cap) / 0 / negative / non-numeric / decimal / cap larger than cart.
- Flat: amount below, equal to, above cart total and above a single item price; flat across multiple lines (proportional split, sums exactly); flat on a cart that later shrinks.
- Cap + scope: cap computed on eligible lines only; cap spread across several scoped lines sums to the cap.
- Cap + minimum cart: ineligible cart gets no discount at all.

## 4. Eligibility: single condition (S-ELIG)
For each of min cart total, max cart total, min item quantity (and others the client defines):
- n-1 (rejected, message says which condition and by how much), n (inclusive pass), n+1 (pass); decimals (999.99 rejected).
- Config edge: 0, negative, non-numeric, huge value.
- Re-evaluation: apply, then change the cart across the threshold both ways; discount must appear/disappear live with no stale state and no manual refresh (FOY bugs: manual coupon not auto-removed below minimum; offer not re-evaluated on qty change; category-total mode applied below threshold).
- Threshold measured after another discount, before/after tax: state the base (open item if unknown).
- Quantity counts units not lines (1 line x 3 vs 3 lines x 1).
- Error message accuracy: min failure shows a "min" message, max failure a "max" message, never swapped.

## 5. Eligibility: combinations (S-COMB)
- Every pair of conditions, and all conditions together (AND logic).
- One-fails-at-a-time matrix: pass all but one condition, for each condition; message names the failing condition.
- Multiple failures at once: clear message.
- Min > Max at config rejected; Min = Max allowed (only that exact total qualifies).
- Qty satisfied by cheap items while total fails (and the reverse).
- Move the cart below -> eligible -> above and back; coupon state tracks every step.

## 6. Usage limits (S-LIMIT)
Definitions come from the requirement; if "total usage limit" and "max uses" both exist, their relationship is a BLOCKER open item.
- Total limit: orders 1..N succeed, N+1 rejected with "limit reached"; limit 1; same customer repeatedly; blank = unlimited; 0/negative/decimal/text rejected at config.
- Per-customer limit: user hits limit, other customer unaffected; phone format variants (`+91 98..` vs `98..`) are the same customer; guest checkout cannot bypass; two concurrent orders by same customer; limit across multiple stores/channels.
- Combined: total vs per-customer, whichever binds first (both directions), per-customer > total, equal values.
- When a use is counted: at order confirmation, not at apply; abandoned cart does not consume; cancelled/returned order restores or consumes per rule (open item if unknown).
- Enforcement at BOTH apply time and checkout/payment time (FOY bugs: usage limit not re-validated at order placement, coupon applied beyond 10/10; cart offer auto-applied with exhausted limit; usage count not incrementing after order).
- Concurrency: two terminals redeem the last use; exactly one succeeds; count never exceeds limit.
- Cart holds the coupon when the last use is consumed elsewhere: rejected at confirmation with a clear error, no silent discount.
- Edit limits after use: lower below used count (coupon unusable, old orders unaffected, no negative remaining); raise after exhaustion (usable again).
- Admin usage counter matches reality after each confirmed order.

## 7. Validity window (S-DATE)
Time zone is a project fact (ask). Use the project zone; below examples use IST (UTC+05:30). IST is AHEAD of UTC.
- Admin form: start today / past (blocked if rule says so) / future; end before start (blocked); start = end (same day); only start; only end; neither; invalid dates (`13/45/2026`, `02/30`); leap day; far future; date picker vs typing give same stored date; reopen shows the same date (no -1 day shift); clearing a date.
- Redemption window (start D, end D+2): D-1 23:59:59 rejected; D 00:00:00 valid (project midnight, not UTC midnight); D+1 noon valid; D+2 23:59:59 valid (end inclusive of whole day, if that is the rule); D+3 00:00:00 rejected.
- Zone discriminators: D 00:00-05:30 IST (UTC still D-1) must already be valid; D+2 05:30-23:59 IST must still be valid (catches an end date stored as UTC midnight, which would expire at 05:30 IST); test with browser/device zone set to UTC and US-Pacific; wrong device clock must not matter (server decides).
- Cart built before expiry, confirmed after: re-validated at confirmation with a clear message; cart left open overnight revalidated.
- Status accuracy: expired coupon status flips to Expired automatically (FOY bug: expired offer remained Active); expired coupon can be re-activated by editing dates (FOY bug: Activate disabled in menu); removing optional end date saves (FOY bugs: ends_at null rejected, removal not saved).
- Pause / resume: paused offer removed from cart, PDP, PLP on next load, no stale price after back-navigation (FOY bugs: paused discount still in cart after qty change, stale PLP price after back).
- Admin list/detail show dates in the project zone without off-by-one.

## 8. Scope, distribution, sequences (S-SCOPE)
Scopes: whole cart, brand, category, product, variant, multiple of each, combo/bundle SKUs.
- Only scoped item in cart; only non-scoped item (rejected with clear message, no discount line); mixed cart: discount only on scoped lines, non-scoped at list price.
- Variant scope: variant A scoped, variant B of the same product is NOT discounted.
- Multi-scope: several products/variants selected, one of them present, none present.
- Per-line distribution: line discounts sum exactly to cart-level discount; fractional per-line amounts rounded by one rule; cap spread across lines.
- Display: scoped line shows discount/badge and reduced price, non-scoped line shows none; summary shows Subtotal, Coupon discount (with code), Payable, consistent with lines; updates without refresh on qty change; identical after reload (server state); matches API response to the paisa; remove coupon reverts.
- Add/remove ORDER sequences: add non-scoped -> apply (rejected) -> add scoped; add scoped -> apply -> add non-scoped (discount not extended); remove the scoped item (discount removed, others untouched); remove the non-scoped item; same final cart built in different order gives same result; add scoped -> apply -> remove -> re-add; rapid add/remove ends in the right state.
- Targets that change: scoped product/variant deleted, archived, renamed, SKU changed (scope follows identity); target changed on an active offer (stale tag, FOY bug: old product retains tag); selected targets visible when re-editing (FOY bugs: brand/category lost on edit, gift product not saved).
- Spoofed IDs via API: eligibility decided from the real cart lines.

## 9. Stacking and combining (S-STACK)
- Same coupon applied twice (applied once only).
- Second manual coupon over an existing one: replaced or rejected per rule; the discount shown is correct immediately, not only after refresh (FOY bugs: wrong value after second coupon; second coupon toast success but not shown; first coupon lost).
- Coupon + auto-apply offer; auto-apply + auto-apply; "can be combined" on/off in both directions (FOY bug: combine setting one-sided on the partner offer); non-combinable offers never stack (FOY bug: "Can Be Combined: No" not enforced).
- Conflict resolution: when two eligible offers compete, the better (higher customer value) wins (FOY bugs: lower-value offer applied over higher, best offer not re-evaluated on qty change, first applied stays locked).
- Combined discounts never push an item price or cart below zero (FOY critical bugs).
- Interplay with loyalty coins / wallet / gift products / free items (FOY bugs: coins applied despite restriction; free item counted in cart badge, missing in order detail, not clickable).
- Cart-visibility off offers do not appear in the offers list (FOY bug); already-applied coupon not shown again with an Apply button (FOY bug); manual coupon not labelled "auto-applied" in admin.

## 10. Order lifecycle and money trail (S-ORDER)
- Cart summary -> payment -> order confirmation -> order detail -> invoice/receipt -> admin order: same discount to the paisa everywhere.
- Tax: GST/VAT computed on the discounted amount; invoice tax split per line correct; tax-inclusive vs exclusive prices.
- Payment modes (prepaid, COD, wallet, split): eligibility and amounts per mode; COD fee interplay.
- Order confirmed with stale/changed cart: coupon re-validated; no order at undiscounted or wrongly discounted price.
- Cancel before and after confirmation: usage count and wallet/coins reversal per rule.
- Return/refund: refund of a discounted line = discounted price; return only non-discounted line = full price; partial return when discount/cap was spread across lines; free/gift item return; coins/wallet reversal; exchange order keeps or drops coupon per rule.
- Integration sync (OMS/WMS/e-commerce platform): discount and line items reach the downstream system correctly.
- Network drop during apply or confirm: no partial state, no usage consumed without an order.

## 11. Admin form and data integrity (S-ADMIN)
- Create with all fields; with required only; submit empty (per-field errors); double-click Create (one coupon); Cancel creates nothing.
- Duplicate code (case-insensitive per rule), code with spaces, code reuse after delete.
- Changing coupon strategy/type resets irrelevant fields; stale value not submitted.
- Permissions (RBAC): user without create/edit/delete permission blocked in UI and API (403); store-scoped user sees only own store.
- Persistence: reopen shows exactly what was saved; list/detail show correct status, dates, usage counter, targets; long names/targets do not break layout (FOY bugs: long variant/offer names).
- Search/filter/sort in coupon list; status filter returns right rows (FOY bug: status filter returned inactive).
- Edit/delete in-use coupon; deleted coupon in an open cart rejected with no crash; deleted offer disappears from PDP.
- Detail page: delete redirects away; back button returns to list (FOY bugs); no raw API/DB error text in toasts.

## 12. Cross-cutting and UI (S-XCUT)
- Apply from typed code, from offers list, from inside the list modal; remove; re-apply after remove (may be blocked by usage rule).
- Code input: lower/upper case, leading/trailing spaces, paste, emoji, very long; empty input blocked or "enter a code" message.
- Invalid/expired/ineligible messages are specific and accurate; no internal state leaked (FOY security finding: paused-offer error enables code enumeration; use one generic message for unknown/paused/inactive codes unless requirement says otherwise).
- Another tab/session: cart changed or item deleted elsewhere; no infinite loop, no stale re-add (FOY bugs).
- Refresh/back/forward keep consistent discount; session expiry/logout clears cart badge and coupon state.
- Mobile: coupon input and Apply stay visible above the keyboard; modal scroll; sticky coupon field; small screens do not truncate totals or badges.
- Large cart (100 lines) performance and correct math; rapid repeated Apply clicks.
- Accessibility basics: focus order, error announced, keyboard-only apply.
- API-level: unauthenticated apply, other user's cart ID, tampered body (negative qty/price), replayed request; responses contain no stack traces or SQL.
