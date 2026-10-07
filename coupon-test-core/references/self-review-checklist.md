# Self-review checklist (run before telling the user it is done)

Run the builder first: it checks Type/Priority values, empty fields, duplicate IDs, numbered steps, and two-outcome wording.
Then check these by reading the JSON/workbook:

**Structure**
- [ ] 4 sheets named: `Cover & Legend`, `Test Cases`, `Summary`, `Mismatches & Open Items`.
- [ ] IDs sequential per prefix with no gaps; Summary totals equal the number of case rows (open the Summary formulas' ranges: they must cover row 3 to last row).
- [ ] Every section has a banner with the right case count.

**Coverage**
- [ ] Every applicable section 1-12 of `scenario-sections.md` has cases; skipped sections are named on the Cover with a reason.
- [ ] Every numeric field and threshold has n-1, n, n+1 (and 0 / negative / non-numeric where it is an input).
- [ ] Each of the one-fails-at-a-time combinations exists when there are 2+ conditions.
- [ ] Re-evaluation cases exist: raise and lower qty/total across each threshold after the coupon is applied.
- [ ] Add/remove ORDER sequences exist for scoped coupons.
- [ ] Usage limits: concurrency, abandoned cart, cancel/return, apply-time AND checkout-time enforcement.
- [ ] Time zone discriminator cases (start of day, end of day, wrong device clock) exist when dates exist.
- [ ] Money trail: cart = order summary = invoice = admin, tax on discounted amount, refund of discounted line.
- [ ] Every pattern in `bug-patterns.md` that the type can produce appears in at least one case.
- [ ] Negative and edge cases are at least 35% of all cases (reference sheets: ~32% N+E; coupon logic needs more).

**Quality of each case**
- [ ] One expected result, judgeable pass/fail, with concrete numbers.
- [ ] No word like "either", "or", "should probably", "defined behaviour" as the outcome. If the rule is unknown: Open Item row + Status `Query` + tag `defect-suspect` only if a bug is known.
- [ ] Arithmetic recomputed: discount, cap, rounding, payable, tax. State rounding rule once in Open Items if unspecified.
- [ ] Prices come from the project's approved test data, not invented SKUs. If none given: placeholders like `<SKU-A, price P>` plus an Open Item.
- [ ] Steps are runnable by someone who never saw the requirement.
- [ ] No automation content (selectors, API calls) in manual columns, except where the check *is* an API-level validation case (written as a manual step with the request body, e.g. "Send POST ... with percent=150").
- [ ] Test-data safety rule printed on Cover and no step violates it.

**Open items**
- [ ] Every assumption made while writing cases has a row (area, what is unclear, who confirms, which case IDs depend on it).
- [ ] Blockers (cannot write one expected result) are marked "BLOCKER" in the Impact column.

**Final message to the user** (short): file path, case count by Type and by Priority, number of Open Items and blockers,
sections skipped. No celebration, no claims beyond what was checked.
