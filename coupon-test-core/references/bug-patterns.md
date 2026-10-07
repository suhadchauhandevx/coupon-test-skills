# Bug patterns to cover (mined from FOY_Bug_Tickets.md, 622 tickets, ~160 offer/coupon related)

Use as a "never miss" checklist. Each pattern must appear in at least one generated case where the coupon type makes it
possible. Ticket IDs are the FOY ClickUp-sheet IDs (use as the Tags/Preconditions source note, e.g. `bug-ref: TC-OFF-BUG-059`).

| # | Pattern | Source tickets | Section |
|---|---|---|---|
| 1 | Auto/manual coupon not re-evaluated when qty changes or item removed; discount stays below the minimum | TC-OFF-BUG-059, TC-BUG "Auto-Apply Offer Not Re-Evaluated on Quantity Change", TC-OFF-BUG-109, TC-OFF-BUG "Paused Product Discount Still Shows After Quantity Change" | S-ELIG, S-SCOPE |
| 2 | Two combinable offers: only one applies | TC-OFF-BUG-039, 043, 052, 053, 054, TC-OFF-BUG "Only One Cart Gift Offer Applied" | S-STACK |
| 3 | Wrong offer wins when two compete (lower value beats higher; first applied stays locked) | TC-BUG "Lower-Value Auto-Apply Offer Applied Over Higher-Value", "Wrong BXGY Offer Applied When Two Conflict", TC-OFFER-BUG-007, TC-OFF-BUG-058 | S-STACK |
| 4 | Second coupon over first: wrong discount shown until refresh; first coupon lost; toast success but not listed | TC-BUG "Incorrect Discount Amount Shown After Applying Second Coupon", TC-OFF-BUG-033, 037 | S-STACK |
| 5 | Non-combinable offer still stacks; "combine" setting one-sided | TC-OFF-BUG-056, TC-OFF-BUG-034, TC-OFFER-BUG-009 | S-STACK |
| 6 | Negative item price / negative cart / raw SQL error when combined or flat discounts exceed price | TC-OFF-BUG-057, TC-OFF-BUG "[CRITICAL] Combined Cart Discounts Cause Negative Item Prices", "[CRITICAL] Cart Crashes with Raw SQL DB Error When Product Flat Discount Exceeds Price", TC-BUG "Flat Product Discount Exceeding MRP Causes Negative Prices and 300%+ Discount %", TC-OFF-BUG-110 | S-MATH, S-CAP |
| 7 | Rounding off by one rupee | TC-OFF-BUG-045 (1468 vs 1469), TC-OFF-BUG "50% Discount Rounding Error (2,400 vs 2,399)", TC-OFF-BUG-049 (decimals in cart) | S-MATH |
| 8 | Usage limit not enforced at order placement or on auto-apply; usage count not incrementing | TC-LOYALTY-BUG "Coupon Usage Limit Not Re-Validated at Order Placement", TC-BUG "Cart Offer Auto-Applied Despite Usage Limit Being Exhausted", TC-BUG "Cart Offer Usage Count Not Incrementing" | S-LIMIT |
| 9 | Clearance/unit cap not enforced; units-sold counter wrong | TC-OFF-BUG (clearance cap, 5/4 sold, 0/4 after 3 units) | S-LIMIT |
| 10 | Expired offer status stays Active; cannot reactivate; end date cannot be removed | TC-BUG "Expired Offer Status Remains Active", "Expired Offer Activate Option Disabled", "Removing Optional End Date ... Throws API Validation Error", "Offer Edit General: Removing End Date Does Not Update" | S-DATE |
| 11 | Paused/deleted offer still shown on PDP/PLP/cart/wishlist; stale price after back navigation; needs manual refresh | TC-OFF-BUG-155, TC-OFF-BUG "Deleted Product Discount Offer Still Displaying", TC-OFF-BUG "Paused Product Discount Not Re-evaluated", GAP-1 | S-DATE, S-XCUT |
| 12 | Offer configured/activated after item in cart not reflected; needs multiple refreshes | TC-OFF-BUG "Product Discount Configured After Item Added to Cart Not Reflected", TC-BUG "Active Product Discount Offer Requires Multiple Refreshes" | S-SCOPE |
| 13 | Free/gift item counted in cart badge; missing from order detail; "Go to Bag" instead of Add; not clickable; wrong position | TC-OFF-BUG-154, TC-BUG "Free Product Not Displayed in Order Detail", "Go to Bag Shown When Product Is Free Offer Item", "Free/Gift Product Not Redirecting to PDP" | S-STACK, S-ORDER |
| 14 | BXGY freebie not added though offer shows applied; wrong paid qty in breakdown; multiplier ignored; gift price not added | TC-OFFER-BUG-008, TC-CART-BUG-002, TC-OFF-BUG-031, 041, 040 | S-SCOPE (BXGY/BXAY) |
| 15 | Applied/auto-applied coupon still listed in Available Offers with Apply; cart-visibility=No ignored; manual coupon shown "Auto-applied" in admin | TC-OFF-BUG-038, TC-OFF-BUG "Cart Visibility: No Still Displaying", TC-ADMIN-BUG "Manually Entered Coupon Shown as Auto-applied" | S-STACK, S-ADMIN |
| 16 | Admin edit form loses/defaults saved targets (brand/category/gift product); wrong target type on open | TC-BUG "Cart Discount Edit Form Loses Selected Brand/Category", "... Defaults to Cart Value", "... Shows Wrong Target Type", TC-OFF-BUG-048, 050 | S-ADMIN |
| 17 | Missing/incorrect admin validation: server accepts offer with no target; required fields; coupon name; max discount vs percentage; min cart > 0 wrongly required; decimals in min cart; helper text contradicts validation | TC-OFFER-BUG-002, 005, 006, TC-BUG "Coupon Name Field No Validation", "Missing Required Field Validation", TC-OFF-BUG-046, 047, "Min Cart Value Incorrectly Required" | S-CFG |
| 18 | Raw API/DB error JSON or SQL shown to user | TC-PLP-BUG-002, TC-OFF-BUG-055, TC-ACC-BUG-103, TC-UI-BUG-026 | S-XCUT |
| 19 | Category/brand cart-value mode applied below threshold; combined brand+category+total miscalculated | TC-OFF-BUG-048 (category), TC-OFF-BUG-125 (brand flat capped at product price) | S-SCOPE |
| 20 | Coupon code enumeration via differentiated error text for paused offers | GAP-1 | S-XCUT |
| 21 | Stale cart/session: coupon or cart persists after logout; cross-tab delete causes loop; order placed with stale cart; cart not cleared after order | TC-BUG "Logged-Out User's Cart Persists", "Stale Cart State Causes Infinite Loop", "Order Placed with Stale Cart Data", "Cart Not Cleared After Order" | S-XCUT, S-ORDER |
| 22 | Mobile: coupon input hidden behind keyboard; sticky input scrolls away; offers popup layout | TC-UI-BUG "Coupon Input Field Disappears Behind Keyboard", TC-CART-UI-BUG "Enter Coupon Code Input Scrolls Away" | S-XCUT |
| 23 | Price/offer display gaps: strikethrough MRP missing, savings label missing at 100%, badge only for some variants, PDP vs PLP mismatch, wrong name ("Product Discount #5") | TC-BUG "MRP with Strikethrough ... Not Displayed", "Discount Percentage Missing When 100% Offer", "Discounted Variant Price and Badge Not Displayed When Only 1-2 Variants", TC-OFF-BUG "Generic Name" | S-SCOPE |
| 24 | Price filter uses MRP not discounted price; sub total ignores discount | TC-BUG "Price Filter Applies to MRP", "Sub Total Not Reflecting Discount" | S-MATH |
| 25 | Loyalty coins interplay: coins applied despite BXGY restriction; overlapping coin tiers apply lower %; refund leaves negative balance | TC-BUG "FOY Coins Applied Despite Being Restricted", TC-LOYALTY-BUG "Overlapping Coin Tiers", TC-BUG "Manual Reward Reversal Causes Negative Coin Balance" | S-STACK, S-ORDER |
| 26 | Race condition at checkout: concurrent stock/usage depletion; order with 0 items; full order refunded for one OOS line | TC-BUG "Race Condition: Order Created with 0 Items", "Full Order Refunded When Only One Line Item OOS" | S-LIMIT, S-ORDER |

How to use: when you write a case that exercises one of these, add a line to Preconditions or Title tail like
`(regression of TC-OFF-BUG-059)` and tag it `regression`. If a bug is still Open in the source sheet, tag the case
`defect-suspect` and state "KNOWN ISSUE ... expected to FAIL" in Expected Result (only when the user confirms the ticket is still open).
