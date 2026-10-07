# Intake: what to extract before writing a single case

Source of truth = the client requirement the user provides (BRD paragraph, ticket, screenshot, chat text, Figma, admin
form description). Read it fully and fill the table below. Anything not stated becomes an **Open Item** (never an invented rule).
Ask the user for missing items in ONE batched message, max 8 questions, grouped; do not block on non-critical ones, record
them as Open Items and continue.

## A. Project facts (usually one-time per project)
| Field | Why it matters |
|---|---|
| Client / project name, version label | Cover sheet, file name |
| Platform(s): web storefront, POS, app, admin | Route column, UI cases |
| Time zone (e.g. IST) | Validity-window cases |
| Currency, rounding rule, tax (GST inclusive/exclusive) | Math, invoice cases |
| ID prefix and next number (e.g. TC-PCT-001) | Unique IDs |
| Test-data safety rule (e.g. "use only TEST_SKU_1..3; never real SKUs; do not confirm orders on live stock") | Printed on Cover; blocks unsafe steps |
| Approved test data: SKUs/variants with prices, test customers, test stores | Real numbers in cases |
| Roles/permissions involved | RBAC cases |

If a repo `CLAUDE.md`, README or an earlier test-case file exists, read it first and take these facts from there; only ask for what is missing.

## B. Coupon definition
| Field | Examples |
|---|---|
| Type / strategy | percentage off, flat off, code-only, BXGY, BXAY, BXGYAZ, quantity-tiered, cart discount |
| Value and allowed range | 1-100 %, any amount > 0 |
| Cap / max reduction | optional rupee cap |
| Eligibility fields | min cart, max cart, min qty, new-customer-only, platform, payment mode |
| Is each boundary inclusive? | n counts as eligible? |
| Base of "cart total" | pre/post tax, pre/post other discounts, scoped subtotal or whole cart |
| Scope ("applies to") | all items, brand, category, product, variant, combos |
| Application mode | manual code, auto-apply, both; visibility in offers list |
| Combining | stackable with other coupons / auto offers / coins / wallet; priority; best-offer rule |
| Usage limits | total, per customer, max uses (relationship between them); counted when |
| Validity | start/end, inclusive end of day, zone |
| Stores / channels | all stores or selected |
| Funding (brand vs platform split) | if the client tracks it |
| Behaviour on edit/pause/delete/expiry | open carts, orders in flight |
| Returns/refunds | refund on discounted line, partial return, coupon restored? |

## C. Surfaces to cover
Admin create/edit/list/detail, cart or POS cart, offers/coupons list modal, checkout/payment, order confirmation,
order detail, invoice/receipt, admin order view, returns/exchanges, downstream sync (OMS/WMS/e-commerce platform), notifications.

## D. Known issues
Ask: "Are there open defects or known quirks for this coupon area?" Use them for `defect-suspect` tags and the Cover sheet
"Known behaviours to watch" block. Also scan `bug-patterns.md` for patterns relevant to this type.

## Output of intake
A short restatement shown to the user before generation:
1. Coupon spec (table B filled, unknowns marked `?`)
2. Open Items list (each: area, what is unclear, who confirms)
3. Sections that will be included / skipped with reasons
4. Estimated case count per section
Proceed to generation once the user says go (or immediately when running in auto mode, stating the assumptions used).
