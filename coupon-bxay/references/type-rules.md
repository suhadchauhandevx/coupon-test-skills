# Type rules: BXAY (Buy X, pay fixed bundle price A)

ID prefix default: `TC-BXAY-NNN`. Model reference: FOY `OFFER_COUPON_TEST_CASES.md` BXAY sections (core, batch-calc, multiplier,
scope, edge, lifecycle, combined, cross-type, UI verification). (FOY) = confirmed on FOY; verify per client.

## What the type is
When the cart holds >= `min_quantity` qualifying units, a batch of `min_quantity` units is charged `bundle_price` in total
(example: buy 2 for 1000). Units outside a full batch are charged at full unit price (FOY). Multiplier OFF: at most one
batch; multiplier ON: floor(qty / min_quantity) batches (FOY). Optional bonus gift quantity/price.

## Fields to find in the requirement (else Open Item)
min_quantity (batch size) | bundle_price | which units form a batch when prices differ (cheapest? any?) | allow_multiplier |
allow_same_sku | scope (brand/category/variant, AND-narrowing) | bundle price higher than the sum of unit prices (allowed? ignored?) |
bonus gift quantity and price | coupon or auto-apply | combining | validity/limits.

## Section emphasis
- **S-CFG**: min_quantity 0/1/negative/decimal/very large (server accepts 0 in FOY: open item), bundle_price 0/negative/decimal/larger than MRP sum, blank, text; irrelevant fields hidden; bonus gift price field helper text (TC-OFF-BUG "Gift Price Field Helper Text Misleading").
- **S-MATH**: exact batch (qty = min) -> total = bundle_price; qty = min-1 -> no offer; remainder units at full MRP (e.g. min 2, price 1000, qty 3 -> 1000 + 1 x unit price); multiplier ON qty 4 -> 2 batches, qty 5 -> 2 batches + 1 full; multiplier OFF qty 4 -> 1 batch + 2 full; Buy-3 variants; batch of mixed-price units (which prices are replaced? open item); bundle price above MRP sum (negative discount must not happen); rounding; recalculation after each qty change up/down and after remove/re-add.
- **S-SCOPE**: brand, category, variant, combined narrowing; non-qualifying item alongside; P-A1 vs P-B1 scope; brand B scope never matching (FOY known gap for BXAY brand_ids).
- **S-STACK**: BXAY + BXAY (best = lower bundle price, FOY), + BXGY, + BXGYAZ, + Quantity-Tiered, Combined OFF/ON, contradiction -> one fires; BXAY with bonus gift: gift quantity multiplied when multiplier ON (TC-OFF-BUG-041), gift price added to total not shown as free (TC-OFF-BUG-040); coupon + auto-apply BXAY (TC-OFF-BUG-044, 042 BXGY not applied when BXAY active).
- **S-ORDER**: batch price persists after cart re-fetch (FOY edge); order applied-offers and invoice show batch price and per-unit allocation; return of one unit of a batch (refund = share of bundle price?) is a BLOCKER open item; PDP/PLP badge.
- **S-LIMIT/S-DATE/S-ADMIN/S-XCUT**: as in scenario-sections.md.

## Default open items
1. Refund amount when one unit of a bundle batch is returned.
2. Which units form the batch when prices differ.
3. Bundle price vs MRP sum when bundle is dearer.
4. Multiplier and bonus-gift interplay.
5. Per-unit price allocation on invoice (tax).
