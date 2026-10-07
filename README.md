# Coupon Test-Case Skills for Claude Code

A family of [Claude Code](https://claude.com/claude-code) skills that turn a client's coupon / offer requirement into a
complete **manual test-case workbook (.xlsx)**. One skill per coupon type, one shared engine underneath.

Test cases only. No automation code is generated.

## What you get

For one coupon type you get one workbook, `<Project>_<CouponType>_TestCases.xlsx`, with four sheets:

| Sheet | Contents |
|---|---|
| Cover & Legend | Client, scope, what is not covered, column guide, tag glossary, test-data safety rule, known behaviours to watch |
| Test Cases | One banner per scenario section, then the cases. Frozen header, filter, dropdowns for Type / Priority / Status |
| Summary | Live `COUNTIFS` formulas per section (P / N / E / Total / Critical) and execution-status counts |
| Mismatches & Open Items | Every assumption or undecided rule: area, what is expected, what is unclear, who must confirm |

Test Cases columns: `ID | Title | Screen | Route | Type (P/N/E) | Priority | Tags | Preconditions | Steps | Expected Result | Status`

Every case has a single, pass/fail-able expected result. Rules nobody has documented are never guessed: they become an
Open Item and the dependent cases get Status `Query`.

## The skills

| Skill | Use it for |
|---|---|
| `coupon-test-core` | Shared engine and the generic entry point (`/coupon-tests`). Holds the workflow, scenario sections, bug patterns, sheet format, review checklist and the workbook builder |
| `coupon-percentage-discount` | Percent-off coupons: percent range, max-discount cap, min/max cart, min qty, limits, dates, scope |
| `coupon-flat-discount` | Fixed-amount coupons: amount vs cart/item value, split across lines, never negative |
| `coupon-code-basic` | Typed code apply / remove / invalid / expired / empty / second coupon, list of available coupons |
| `coupon-bxgy` | Buy X Get Y (free or discounted): same pool, different pool, specific variant, multiplier |
| `coupon-bxay` | Buy N for a fixed bundle price, batch and remainder, multiplier |
| `coupon-bxgyaz` | Buy X Get Y at Z% off or a fixed price |
| `coupon-qty-tiered` | Buy more, save more tiers (percentage / flat / mixed) |
| `coupon-cart-discount` | Cart discount on total / brand / category cart value with cap and funding split |

## Install

Requires Claude Code and Python 3.9+.

```bash
git clone <this-repo-url> coupon-test-skills
cd coupon-test-skills
./install.sh
```

`install.sh` copies the nine skill folders to `~/.claude/skills/` and creates a Python virtual environment inside
`coupon-test-core/` with `openpyxl` (used only to write the .xlsx). Nothing is installed globally.

Manual install: copy every `coupon-*` folder into `~/.claude/skills/`, then:

```bash
cd ~/.claude/skills/coupon-test-core
python3 -m venv .venv && .venv/bin/pip install openpyxl
```

Restart Claude Code (or start a new session) so the skills are picked up.

## How to use it

### 1. Pick the skill that matches the coupon

In Claude Code, type the slash command with the requirement. The requirement can be pasted text, a file path, a ticket,
a screenshot or a screen recording of the create-coupon flow.

```
/coupon-percentage-discount  Admin > Store Coupons > Create has Percent off (1-100), Max reduction, Min/Max cart total,
                             Min item quantity, Total usage limit, Usage limit per customer, Valid from/until (IST),
                             and "Applies to" All items / products / variants. Client: Acme. Test SKUs: TEST_SKU_1..3.

/coupon-bxgy  /path/to/screen-recording.mov     # describe or attach the create flow
/coupon-flat-discount  <requirement text>
/coupon-code-basic  <requirement text>
/coupon-tests  <requirement>                    # generic entry; asks which coupon type
```

Or just ask in plain words ("create test cases for our BXGY coupon"); the skill descriptions let Claude choose.

### 2. What happens

1. **Intake.** Claude reads your requirement and fills a coupon spec (type, value range, cap, eligibility, scope, stacking,
   limits, dates, time zone, tax, test data, returns). It also reads the project `CLAUDE.md` or README if present.
2. **Open items.** Anything that changes an expected result but is not stated becomes an Open Item. Claude asks the critical
   ones in one batched question, or continues with explicit assumptions if you tell it to proceed.
3. **Write cases** across the scenario sections below, with n-1 / n / n+1 boundaries and recomputed numbers.
4. **Build** the workbook with `coupon-test-core/scripts/build_xlsx.py`, which also validates it.
5. **Self-review** against `references/self-review-checklist.md`, then a short report: path, counts, open items, blockers.

### 3. Give Claude these facts for the best result

| Fact | Why |
|---|---|
| Client / project name and version label | Cover sheet and file name |
| Where the coupon is created and redeemed (admin page, POS, web, app) | Route column and UI cases |
| Time zone (for example IST) | Validity-window cases |
| Currency, rounding rule, tax (GST inclusive or exclusive) | Math and invoice cases |
| Approved test SKUs / variants with prices, test customers | Real numbers in cases; the safety rule printed on the Cover |
| Known open bugs for this area | `defect-suspect` tags and the "known behaviours" block |

If prices are missing, cases use clearly marked illustrative amounts and an Open Item asks for the real ones.

### 4. Scenario sections every workbook uses

| Code | Section |
|---|---|
| S-CFG | Configuration validation (boundaries, negative, text, decimals, API bypass, edit-after-create) |
| S-MATH | Discount math (rounding, multi-line, quantity, never negative) |
| S-CAP | Cap / max discount / amount vs cart |
| S-ELIG | Eligibility: single condition (min cart, max cart, min quantity, re-evaluation on cart change) |
| S-COMB | Eligibility: combinations (pairs, all conditions, one-fails-at-a-time) |
| S-LIMIT | Usage limits (total, per customer, concurrency, abandoned cart, cancel/return) |
| S-DATE | Validity window (admin rules, redemption window, time-zone boundaries, expiry, pause/resume) |
| S-SCOPE | Scope (cart / brand / category / product / variant), per-line distribution, add-remove sequences |
| S-STACK | Stacking and combining (coupon + coupon, + auto offer, + wallet / coins) |
| S-ORDER | Order lifecycle (price summary, invoice and tax, cancel, return / refund, exchange, order sync) |
| S-ADMIN | Admin form, list, permissions, persistence |
| S-XCUT | Cross-cutting and UI (double apply, other tab, network drop, mobile keyboard, API tampering, code enumeration) |

Each type skill adds its own emphasis on top (for example buy/get item pools for BXGY, batch and remainder for BXAY,
tier boundaries for quantity-tiered).

### 5. Reading the result

- **Type:** P positive, N negative, E edge.
- **Priority:** Critical (money, security, blockers), High, Medium, Low.
- **Tags:** smoke, sanity, regression, negative, boundary, edge, integrity, rbac, gap-coverage, defect-suspect.
- **Status:** starts as `Not Run`. `Query` means the case waits on an Open Item. Update to Pass / Fail / Blocked as you execute.
- Work the Open Items sheet first: blockers there decide what many cases should expect.

## Repository layout

```
coupon-test-core/
  SKILL.md                          workflow and rules
  references/
    intake-questionnaire.md         what to extract from the requirement
    scenario-sections.md            the 12 sections with case families
    bug-patterns.md                 26 recurring coupon/offer defect patterns to cover
    sheet-format.md                 exact workbook layout and JSON schema
    self-review-checklist.md        checks before delivery
  scripts/build_xlsx.py             JSON -> workbook builder and validator
coupon-<type>/
  SKILL.md                          trigger and one-paragraph description
  references/type-rules.md          type-specific rules, extra sections, default open items
install.sh                          copies skills to ~/.claude/skills and creates the venv
```

## Adding a new coupon type

1. Create `coupon-<type>/SKILL.md` with a trigger, a description, and a line telling Claude to run the
   `coupon-test-core` workflow with `references/type-rules.md`.
2. Create `coupon-<type>/references/type-rules.md`: what the type is, fields to find in the requirement, section emphasis,
   extra bug patterns, default open items.
3. Re-run `./install.sh`.

Rules that apply to every coupon type belong in `coupon-test-core/references/scenario-sections.md`.

## Ground rules baked into the skills

- Never invent client behaviour, prices or SKUs: unknown means an Open Item.
- One expected result per case.
- Respect the project's test-data safety rule (for example "approved test SKUs only") and print it on the Cover sheet.
- IST is UTC+05:30 and ahead of UTC; time-zone cases use early-morning start-date and late end-date boundaries.
- Existing test-case files are never edited; a new workbook is written.

## Roadmap

Product discount, clearance, cart gift, coins combination, a cross-type combine matrix, and optional automation columns
(API setup, selectors, cleanup) for teams that want to feed the cases into Playwright later.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Skill not offered after install | Restart Claude Code or open a new session |
| `ModuleNotFoundError: openpyxl` | `cd ~/.claude/skills/coupon-test-core && python3 -m venv .venv && .venv/bin/pip install openpyxl` |
| Builder prints `ERROR` | Fix the listed case (bad Type/Priority, empty field, duplicate ID) and re-run |
| Builder prints `WARN` about two outcomes | Rewrite the expected result to one outcome and move the decision to Open Items |
| Summary shows 0 counts in a viewer | Open in Excel/LibreOffice/Numbers so the formulas calculate |
