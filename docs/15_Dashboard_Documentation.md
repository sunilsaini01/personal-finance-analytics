# Power BI Dashboard Analysis & Documentation

# Card Transaction & Merchant Analytics

---

## How to Read This Document

This is a BI-consultant-style review of the three Power BI pages in [`dashboard/Personal_Finance_Analytics.pbix`](../dashboard/Personal_Finance_Analytics.pbix), based on the six screenshots in [`../screenshots/`](../screenshots/) (a default view and a filtered/drilled "Ex." view per page). Every number, chart shape, and label quoted below is taken directly from those screenshots — nothing is invented, and where a screenshot shows something ambiguous or likely wrong, it's flagged as such rather than smoothed over.

Parts 1–8 are done **per page** (three times). Part 9 (Interview Preparation) is done **once**, for the dashboard as a whole — a real interview will ask about the project, not repeat identical questions per page.

Pages covered, in file order:

1. Personal Finance Analytics Dashboard → **Executive Overview**
2. Customer Analytics Dashboard → **Customer Analytics**
3. Transaction Analytics Dashboard → **Transaction Analytics**

---

# Page 1: Executive Overview

## Part 1 — Dashboard Overview

**Professional title:** Executive Revenue & Payment Overview

**Business objective:** Give a single-page, date-filterable snapshot of overall card-spend performance — total volume, transaction activity, customer/card base size, and where revenue concentrates by merchant category and payment channel — so a non-technical stakeholder can assess "how is the business doing" in under a minute.

**Target audience:** VP of Product Analytics / executive sponsor, Finance Director. This is the page built for someone who wants headline numbers and trend direction, not row-level detail.

**Business questions answered:**
- What is total revenue, transaction volume, customer count, and card count, overall and for any selected time period?
- What is the average transaction value and average revenue per customer?
- How does revenue trend month over month?
- Which merchant categories generate the most revenue?
- Which payment channel (swipe / chip / online) dominates transaction volume?

## Part 2 — Visual-by-Visual Analysis

| Visual | Measures | Interpretation | Why it matters | Decision support |
|---|---|---|---|---|
| Dynamic title card ("Executive Overview (All Dates)" / "(Jan 2010 - Jan 2010)") | Text measure driven by the date slicer selection | The page title itself restates the active filter | Removes any ambiguity about what period the numbers below represent — critical the moment this is screenshotted into a report | Prevents a stakeholder from misreading a filtered view as the full-history number |
| Date hierarchy slicer (Year → Month Name → Day → Date) | Drill slicer on `dim_date`-equivalent date parts | Collapsed = whole history; expanded, as shown in the "Ex." capture, lets the viewer drill to a single year/month/day | Standard time-intelligence slicer pattern | Lets an exec self-serve "show me just January 2010" without a new page |
| **Total Revenue** KPI card | `SUM(amount)` over in-scope transactions | 571.84M for full history; 519.71 for the single month Jan 2010 in the filtered view | The single most-asked executive number | Headline for board/exec reporting |
| **Total Transactions** KPI card | `COUNT(transaction_id)` | 13M full history; 14 for Jan 2010 in the filtered view | Activity/volume proxy | Distinguishes "more revenue from more transactions" vs. "from higher-value transactions" |
| **Total Customers** KPI card | `DISTINCTCOUNT(user_id)` | 1K full history; 11 for the filtered month | Active customer base size | Denominator for per-customer metrics; tracks base growth |
| **Total Cards** KPI card | `DISTINCTCOUNT(card_id)` | 4K full history | Card-to-customer ratio context (4K cards / 1K customers ≈ 4 cards/customer) | Card issuance/adoption signal |
| **Average Transaction** KPI card | `SUM(amount) / COUNT(transaction_id)` | Displays as `$42.9760...` — the value is **visibly truncated/overflowing its card** in both the default and filtered views | Average basket size is a standard spend-behavior metric | As displayed, it's not usable for reporting — see Part 6/7 |
| **Avg Revenue / Customer** KPI card | `SUM(amount) / DISTINCTCOUNT(user_id)` | 469.10K full history | Customer value proxy | Feeds any "high value customer" framing used on Page 2 |
| Monthly Revenue Trend (line) | `SUM(amount)` by Year-Month | Full-history view shows a large spike to ~0.6bn at a leading **"(Blank)"** category, then the line drops to near-zero for the remaining ~2010–2019 months | A time trend is the standard way to show growth/decline | **As currently built, this chart is not trustworthy** — see the data-quality flag below |
| Monthly Transactions (bar) | `COUNT(transaction_id)` by Year-Month | Same shape: one oversized "(Blank)" bar (~10M+), then near-zero for every dated month | Same purpose as above | Same flag applies |
| Top 10 Merchant Categories (bar) | `SUM(amount)` by `dim_mcc.description`, top 10 | Money Transfer leads (~50M+), followed by Grocery Stores/Supermarkets, Wholesale Clubs, Drug Stores and Pharmacies, Service Stations, Utilities, Department Stores, Eating Places and Restaurants, Automotive Service Shops, Telecommunication Services | Directly answers "what drives spend" | Tells merchant-partnership and category-management teams where the volume is |
| Payment Method Distribution (donut) | `COUNT(transaction_id)` by `use_chip` | Swipe 52.36% (7M), Chip 35.93% (5M), Online 11.71% (2M) | Channel-mix visibility | Informs where to invest in payment infrastructure (see Part 5) |

**Data-quality flag (visible in the screenshot, not assumed):** both time-series visuals show a disproportionate value sitting in a `(Blank)` category rather than a distributed trend across 2010–2019. That pattern — one oversized "blank" bucket plus a flat near-zero line for every real date — is the classic signature of either (a) a set of transactions with a `NULL`/unparsed `txn_date` being grouped into a blank bucket, or (b) a fan-out join in the report's data model inflating one aggregate. This should be root-caused in the PBIX data model / DAX before this chart is shown to anyone — right now it actively misrepresents the revenue trend. This same pattern reappears on Page 3, which suggests a shared root cause (likely the same underlying date table or relationship) rather than two unrelated bugs.

## Part 3 — Business Insights

- **Payment channel is still swipe-dominant, not chip-dominant** (52.36% swipe vs. 35.93% chip), and the filtered Jan-2010 view shows **zero chip transactions at all** (85.71% swipe / 14.29% online, no chip slice). This lines up with the real-world EMV chip rollout timeline — chip terminals weren't in wide circulation in 2010 — which is a good, defensible sanity-check that the payment-channel data behaves the way history says it should.
- **Money Transfer is the single largest revenue category** by a wide margin over the next-highest category (Grocery Stores/Supermarkets), both in the full-history view and in the Jan-2010 slice — this category consistently tops the list regardless of period, making it the dominant driver worth a dedicated deep-dive.
- **Necessity-driven categories dominate the top 10** (grocery, wholesale clubs, drug stores/pharmacies, service stations, utilities) over discretionary categories — the top-10 list reads like recurring/essential spend rather than discretionary retail.
- **Average revenue per customer (469.10K) alongside ~4 cards per customer (4K cards / 1K customers)** suggests multi-card ownership is the norm in this base, not the exception.
- The month-level drill-down (Jan 2010: 14 transactions, 11 customers, $519.71 revenue) confirms the report's drill path works correctly end-to-end, from year down to a single month, with every visual on the page cross-filtering consistently.

## Part 4 — Executive Summary

The Executive Overview page shows a card-transaction book with 571.84M in total revenue across 13M transactions, roughly 1,000 customers holding about 4,000 cards. Money Transfer is the dominant spend category by a clear margin, trailed by grocery, wholesale, pharmacy, and fuel spend — a top-10 list that skews toward necessity spend rather than discretionary categories. Payment behavior still leans on swipe transactions (52%) over chip (36%) and online (12%), and the earliest years in the dataset show essentially no chip usage at all, consistent with the real-world EMV chip adoption curve — a useful sanity check that the underlying data behaves plausibly. The date-hierarchy slicer and dynamic page title work correctly end-to-end, letting a viewer drill from full history down to a single month with every visual updating in sync. The one item management should not treat as final: both time-series visuals on this page (Monthly Revenue Trend and Monthly Transactions) currently show a large, unexplained "(Blank)" spike followed by a near-flat line, which misrepresents the actual month-over-month trend and needs to be root-caused in the data model before this page is used for trend reporting.

## Part 5 — Business Recommendations

1. **Fix the Monthly Revenue Trend / Monthly Transactions "(Blank)" spike before this page goes in front of any stakeholder** — a trend chart that's actually flat-lined is worse than no trend chart at all.
2. **Reformat the Average Transaction KPI card** to a rounded currency format (e.g., `$42.98`) — the current display overflows the card and is unreadable in both the base and filtered states.
3. **Double the investment focus on Money Transfer merchant relationships/fees** given it is the single largest and most consistent revenue category across every time period viewed.
4. **Prioritize swipe and chip infrastructure reliability over online** given swipe+chip still make up ~88% of transaction volume — but track the online share over time, since it's the channel most likely to grow.
5. **Use the necessity-skewed top-10 category mix (grocery, pharmacy, fuel, utilities) as a segmentation input** — a base this weighted toward essential spend behaves differently in a downturn than a discretionary-heavy one, which matters for any future credit-risk framing.
6. **Reconcile the payment-method donut total (7M+5M+2M ≈ 14M) against the Total Transactions KPI (13M)** — the ~1M gap should be explained (e.g., a small "unknown"/blank `use_chip` slice not shown in the donut) rather than left as a silent rounding difference.

## Part 6 — Dashboard Design Review

| Category | Score /10 | Rationale |
|---|---|---|
| Layout | 7 | Clean 2x3+ grid, logical KPI-row-then-charts flow; consistent with Page 2 |
| Color usage | 6 | Muted green background + navy accents is calm but low-contrast against white KPI cards; donut and bar colors aren't tied to a broader palette |
| KPI placement | 7 | All six KPIs in one row at the top, correctly the first thing the eye hits |
| Chart selection | 8 | Line for trend, bar for ranking/category, donut for channel mix — all textbook-appropriate choices |
| Readability | 5 | Average Transaction card text overflow, and dense/overlapping x-axis labels on both time-series charts, hurt this materially |
| White space | 7 | Card spacing is even; no visual crowding |
| Consistency | 8 | Matches Page 2's visual language (same KPI card style, same slicer pattern) |
| Visual hierarchy | 7 | KPIs → trend → category/channel is a sensible top-to-bottom narrative |
| Accessibility | 5 | Single navy/blue palette for the donut categories has low hue separation for colorblind viewers; no visible alt-text/tooltip enrichment beyond default |
| User experience | 6 | Drill-down and dynamic title work well; undermined by the trend-chart data issue and KPI overflow |

## Part 7 — Improvement Suggestions

- **Additional KPIs:** Revenue Growth % (MoM/YoY), Median Transaction Value (less skewed by outliers than the average), Active Customers in Period (vs. lifetime Total Customers).
- **Better DAX measures:** wrap the Average Transaction measure in `FORMAT(..., "$#,##0.00")` or set the card's display units explicitly; add an explicit `CALCULATE(..., REMOVEFILTERS())` variant for the "all-time" reference number so it can be shown alongside the filtered number.
- **Better filters/slicers:** collapse the date hierarchy slicer to a compact date-range slider option for exec use, reserving the full hierarchy drill for an analyst view.
- **Drill-through:** add a drill-through from any Top-10-Merchant-Category bar straight to a merchant-detail page (ties naturally into Page 3's merchant/category visuals).
- **Tooltips:** the default line-chart tooltip already shows period + value (seen in the "Ex." screenshot) — extend it to also show MoM % change.
- **Dynamic titles:** already implemented well here (`Executive Overview (Jan 2010 - Jan 2010)`) — replicate this pattern on Page 3, which currently has a static, non-date-aware title.
- **Performance:** if the "(Blank)" spike is caused by a fan-out relationship, fixing the model relationship will likely also improve refresh/render performance, not just correctness.

---

# Page 2: Customer Analytics

## Part 1 — Dashboard Overview

**Professional title:** Customer Demographics & Value Analytics

**Business objective:** Break total revenue down by who the customer is — gender, age band, income, credit score, and card brand — to identify which customer segments carry the most value and what their credit/demographic profile looks like.

**Target audience:** Marketing/Growth lead, Product Manager for any premium-tier or loyalty initiative, and secondarily a Risk/Credit analyst (credit score and debt are both surfaced here).

**Business questions answered:**
- Which customers generate the most revenue (top 20), and how concentrated is revenue among them?
- How does revenue differ by gender and by age group?
- What's the relationship between a customer's income and their revenue?
- What does the credit-score distribution of the active card base look like?
- Which card brand generates the most revenue?
- What are the average income, credit score, debt, and age for any selected demographic slice?

## Part 2 — Visual-by-Visual Analysis

| Visual | Measures | Interpretation | Why it matters | Decision support |
|---|---|---|---|---|
| "age.gender" slicer (drill hierarchy) | Age Group → Gender, drilldown | Collapsed = "All"; the "Ex." capture shows it drilled to `18-24 → Female`, with a further level showing values like `497.00, 495.00...` | Same drill-slicer pattern as Page 1's date hierarchy | Lets a marketer isolate one demographic cell (e.g., "young women") in one click |
| **Average Income** KPI | `AVERAGE(dim_users.yearly_income)` | 45.72K overall; 48.36K for 18-24/Female slice | Baseline affluence of the customer base | Anchors any premium-tier income-based targeting |
| **Avg Crd Score** KPI | `AVERAGE(dim_users.credit_score)` | 709.73 overall; 712.67 for the 18-24/Female slice | Credit-quality proxy for the base | Relevant to any credit-risk or premium-card eligibility framing |
| **Average Debt** KPI | `AVERAGE(dim_users.total_debt)` | 63.71K overall | Leverage/financial-stress proxy | Pairs with income to assess segment financial health |
| **Average Age** KPI | `AVERAGE(dim_users.current_age)` | 45.39 overall; 20.60 for the 18-24/Female slice (consistent with the filter) | Demographic center of the base | Confirms the slicer is filtering the right population |
| Revenue by Gender (bar) | `SUM(amount)` by `gender` | Female slightly exceeds Male in total revenue, both overall and (more sharply) within the 18-24 slice | Gender-level spend comparison | Input to any gender-targeted campaign decision — see caution in Part 5 |
| Revenue by Age Group (bar) | `SUM(amount)` by age band | 45-54 leads, then 65+, 35-44, 55-64, 25-34, with 18-24 the smallest visible segment | Age-band value ranking | Prioritizes which age cohort a premium offer should target first |
| "Income vs Revenue" (scatter) | `yearly_income` vs. `SUM(amount)` per `user_id` | Points sit almost on a single horizontal line rather than showing a clear income/revenue relationship | Meant to show whether higher income correlates with higher spend | **Likely a chart-configuration issue** — see flag below |
| Credit Score Distribution (histogram) | `COUNT(user_id)` by `credit_score` bucket | Dense cluster of thin bars across roughly 400–800+ | Shows the shape of the base's credit quality | Distinguishes a subprime-heavy base from a prime-heavy one |
| Top 20 Customers by Revenue (bar) | `SUM(amount)` by `user_id`, top 20 | Descending ranking from just under 2M down | Direct list of highest-value accounts | Feeds any VIP/relationship-management outreach list |
| Total Revenue by card_brand (bar) | `SUM(amount)` by `card_brand` | Mastercard highest, then Visa, then Amex and Discover markedly smaller | Card-network revenue mix | Relevant to any card-network partnership or co-brand negotiation |

**Chart-configuration flag (visible in the screenshot):** the "Income vs Revenue" scatter plot shows all points landing at nearly the same vertical position regardless of income — a true income-vs-revenue scatter should show vertical spread proportional to `yearly_income`. The tooltip data is correct (the "Ex." capture confirms a point with `yearly_income: 41714`, `user_id: 963`, `Total Revenue: 125006.91`), so the underlying data is fine — this looks like the Y-axis field or its aggregation/scale is not actually driving vertical position the way the chart title implies. Worth checking the Y-axis field binding before trusting this visual for any income-correlation claim.

**Labeling flag:** the slicer header literally reads `age.gender` — a raw field/hierarchy name rather than a user-facing label (e.g., "Age Group & Gender"). Minor, but it's the kind of thing a reviewer notices immediately.

## Part 3 — Business Insights

- **Female customers generate marginally more total revenue than male customers**, and that gap widens noticeably within the 18-24 age band specifically (visible in the "Ex." filtered view) — worth a closer look at whether this holds across all age bands or is concentrated in younger cohorts.
- **The 45-54 age band is the single highest-revenue age group**, ahead of 65+ — the customer base's peak value segment is solidly mid-career, not retirees or young adults.
- **Mastercard and Visa dominate revenue** over Amex and Discover by a wide margin, both overall and within the 18-24/Female sub-segment (where Amex/Discover essentially disappear) — network preference may itself correlate with age/income segment.
- **Average credit score (709.73) sits in prime territory**, and it's slightly *higher*, not lower, for the youngest slice shown (712.67 for 18-24/Female) — worth verifying this isn't an artifact of a small sample size in that filtered cell before drawing a "young customers are lower-risk" conclusion.
- **The Top 20 Customers by Revenue chart shows a steep drop-off**, consistent with typical revenue concentration (a small number of accounts driving a disproportionate share) — a good candidate for an explicit 80/20 concentration callout (see Part 7).

## Part 4 — Executive Summary

The Customer Analytics page profiles the ~1,000-customer base by demographics and value. Average income sits at 45.72K, average credit score at 709.73 (prime territory), and average debt at 63.71K, with a base-wide average age of 45.39. Revenue skews mid-career: the 45-54 age band outperforms every other cohort, including 65+, and Mastercard and Visa together account for the large majority of card-brand revenue over Amex and Discover. Female customers generate marginally more revenue than male customers overall, a gap that widens in the youngest age band. The Top 20 Customers by Revenue chart shows the expected steep concentration curve, making it a ready-made VIP outreach list. Demographic drill-down (age band × gender) works correctly and cross-filters every visual on the page consistently, confirmed by the Jan-2010-style filtered capture. One visual needs attention before being trusted operationally: the "Income vs Revenue" scatter plot does not currently show a visible income/revenue relationship, with points clustering on a single line — the underlying tooltip data is correct, so this is most likely a chart Y-axis binding issue rather than a data problem, but it should not be used to support any income-correlation claim until fixed.

## Part 5 — Business Recommendations

1. **Build a targeted retention/loyalty offer for the 45-54 age band** — it's the clear top-value cohort and is likely under-targeted relative to younger, more heavily marketed-to segments.
2. **Investigate the female-revenue gap in the 18-24 cohort specifically** — if it holds up outside this one filtered snapshot, it's a concrete, actionable segment for a marketing campaign.
3. **Fix the Income vs Revenue scatter's Y-axis binding** before using it in any income-correlation analysis or stakeholder deck.
4. **Use the Top 20 Customers by Revenue list as the seed for a relationship-management / VIP program**, since the drop-off shape suggests meaningful revenue concentration.
5. **Explore a Mastercard/Visa co-brand or rewards partnership** given how dominant those two networks are in revenue share, versus a lower-priority stance on Amex/Discover.
6. **Relabel the "age.gender" slicer** to a business-friendly name before this dashboard is shown externally.
7. **Add an explicit revenue-concentration KPI** (e.g., "Top 20 customers = X% of total revenue") rather than leaving the reviewer to infer concentration from the bar chart's shape.

## Part 6 — Dashboard Design Review

| Category | Score /10 | Rationale |
|---|---|---|
| Layout | 7 | Consistent 2-column grid matching Page 1 |
| Color usage | 6 | Same green/navy palette as Page 1 — consistent, but the scatter plot's per-customer color-by-`user_id` legend (20+ swatches) is not a usable color encoding at that cardinality |
| KPI placement | 8 | Four KPIs in a clean top row, directly under the slicer |
| Chart selection | 5 | Bar and histogram choices are right; the scatter plot is the wrong tool as currently configured (see flag above) |
| Readability | 6 | KPI cards read cleanly; the scatter's color legend and the credit-score histogram's dense bars are harder to parse at a glance |
| White space | 7 | Even spacing, no crowding |
| Consistency | 8 | Strong visual match to Page 1 |
| Visual hierarchy | 6 | KPIs first is right, but the broken scatter plot pulls attention without rewarding it |
| Accessibility | 5 | Per-point categorical coloring by `user_id` is not colorblind-safe and doesn't scale past a handful of categories |
| User experience | 7 | Drill/cross-filter behavior across all visuals works correctly and consistently, which is the most important UX property for an exec self-serve page |

## Part 7 — Improvement Suggestions

- **Additional KPIs:** Revenue Concentration % (Top 20 / Total), Average Revenue per Customer within the current slice (mirrors Page 1's overall version), New vs. Returning Customer split if `dim_users` supports a signup/first-transaction date.
- **Better visuals:** replace the per-`user_id`-colored scatter with either a binned income-band-vs-average-revenue bar/line, or a proper scatter with a continuous color/size gradient on income instead of a categorical legend.
- **Better DAX measures:** a measure for revenue concentration (`Top N Revenue / Total Revenue`) to put a number on what the Top-20 chart currently only implies visually.
- **Better filters/slicers:** rename `age.gender` to a readable label; consider splitting it into two independent slicers (Age Group, Gender) so a user can filter by one without the other.
- **Drill-through:** click a bar in Top 20 Customers → drill through to a single-customer profile page (transactions, cards, category mix).
- **Tooltips:** add income and credit score to the Top 20 Customers bar tooltip so a viewer doesn't have to cross-reference the scatter plot.
- **Bookmarks:** a bookmark toggling between "All Customers" and "Top 20 Customers Only" would let a presenter jump straight to the VIP view.

---

# Page 3: Transaction Analytics

## Part 1 — Dashboard Overview

**Professional title:** Transaction Success, Risk & Geographic Analytics

**Business objective:** Monitor transaction-level operational health — success/failure rate, failure reasons, volume trend, and geographic revenue distribution — so operations and risk teams can spot reliability problems before they compound.

**Target audience:** Operations Manager and Risk/Fraud team primarily; secondarily a Finance Director interested in geographic revenue spread.

**Business questions answered:**
- What share of transactions succeed vs. fail, overall and for any selected year/state/payment-channel slice?
- How many transactions failed, and for what reasons?
- How does transaction volume trend over time?
- Which merchant categories generate the most revenue?
- How is revenue distributed geographically (by state)?

## Part 2 — Visual-by-Visual Analysis

| Visual | Measures | Interpretation | Why it matters | Decision support |
|---|---|---|---|---|
| **Success Rate** KPI (left, green) | `Successful Transactions / Total Transactions` | 0.98 overall; 0.98 for the 2011 slice (196/199 ≈ 0.985) | Headline operational-health metric | Immediate signal of platform reliability |
| **Success Rate** KPI (right, green) — **mislabeled** | Same ratio, inverted | Card header reads "Success Rate" but the caption underneath reads "Failure Rate," showing 0.02 (0.02 for 2011: 3/199 ≈ 0.015) | The math is correct; **the card title is wrong** — a copy-paste-and-edit artifact | As-is, this card actively misleads a first-time viewer into thinking there are two success-rate cards showing different numbers |
| Interactive Filters (combined slicer: Year, Month Name, `merchant_state`, `use_chip`) | Multi-field slicer | Collapsed = "All"; "Ex." capture shows it drilled to Year = 2011 | One slicer driving four dimensions of filtering | Lets ops narrow to "this year, this state, this channel" in one control |
| Total Transactions KPI | `COUNT(transaction_id)` | 13M overall; 199 for 2011 slice | Volume | Denominator for every rate metric on the page |
| Average Transaction KPI | `SUM(amount) / COUNT(transaction_id)` | `$42.9760...` overall (same overflow issue as Page 1); `$47.8236...` for 2011 | Basket-size trend | Same overflow issue flagged on Page 1 — recurring, not one-off |
| Successful Transactions KPI | `COUNTROWS(FILTER(..., errors = BLANK()))` (inferred) | 13M overall; 196 for 2011 | Volume of clean transactions | Numerator for Success Rate |
| Failed Transactions KPI | Complement of Successful | 211K overall; 3 for 2011 | Volume of problem transactions | Numerator for Failure Rate; direct input to an ops alert threshold |
| Monthly Transactions Trend (line) | `COUNT(transaction_id)` by Year-Month | Same "(Blank)"-spike-then-flat pattern seen on Page 1; the 2011 slice shows a cleaner declining line with a tooltip reading "2011-07: 19" | Volume trend over time | Same data-quality flag as Page 1 applies here |
| Top 10 Merchant Categories by Revenue (bar) | `SUM(amount)` by `dim_mcc.description` | Same top categories as Page 1 (Money Transfer leads); reorders sensibly under the 2011 filter (Telecommunication Services and Drinking Places/Betting appear higher in that year's mix) | Cross-checks Page 1's category ranking from a transaction-operations lens | Confirms category concentration isn't a one-page artifact |
| Revenue by State (map) | `SUM(amount)` by `merchant_state`, choropleth | Full-history view is zoomed to a **world map** with only North America shaded — every other continent renders empty; the 2011 slice zooms into the US/Mexico region and shows several shaded US states | Geographic revenue spread | Useful once zoomed correctly; wastes space at the default zoom level |
| Transaction Error Distribution (100% bar) | `COUNT(transaction_id)` by `errors`, share of total | Full history: large "(Blank)" (no error) segment, then Insufficient Balance, Bad PIN, Technical Glitch, Bad Card Number, Bad Expiration, Bad CVV, Bad Zipcode, and several **compound** multi-reason strings (e.g., "Bad PIN,Insufficient Balance"); 2011 slice shows only 3 segments, matching the 3 failed transactions exactly | Root-cause breakdown of failures | Tells ops/risk exactly which failure modes to fix first |

## Part 3 — Business Insights

- **Overall success rate is high (98%)**, and the failure count (211K out of 13M) is small in relative terms but not trivial in absolute terms — 211K failed transactions is still a meaningful volume for an ops team to triage.
- **Insufficient Balance and Bad PIN are the two leading named failure reasons**, both in the full-history error breakdown and in the 2011 slice (where all 3 failures map to "(Blank)"/Insufficient Balance/Bad PIN) — these two reasons alone look like the highest-leverage fix targets.
- **A meaningful share of failures are compound (multi-reason) codes** (e.g., "Bad PIN,Insufficient Balance"), meaning a single failed transaction can carry more than one root cause — a naive single-reason failure analysis would undercount the true incidence of each individual failure mode.
- **Category ranking is consistent across pages**: Money Transfer tops both the Executive Overview's and the Transaction Analytics page's Top-10 list, which is a good internal-consistency check on the underlying model.
- **Geographic revenue is concentrated in North America**, consistent with this being a US-issued card dataset — the map's empty rest-of-world is itself informative (there's effectively no non-US revenue to report), though the current zoom level buries that finding rather than stating it.
- **Year-level filtering (2011) shows a declining monthly transaction count within the year** (per the tooltip trend from ~20 down over the shown months) — worth checking whether this is a real seasonal pattern or an artifact of the same "(Blank)" date issue flagged elsewhere.

## Part 4 — Executive Summary

The Transaction Analytics page reports a 98% success rate across 13 million transactions, with roughly 211,000 failures. Insufficient Balance and Bad PIN are the two most common named failure reasons, and a nontrivial share of failures carry compound, multi-reason error codes — meaning failure-mode analysis needs to account for transactions with more than one contributing cause rather than assuming one reason per failure. The merchant-category ranking on this page (Money Transfer leading, followed by grocery, pharmacy, and utility spend) matches the Executive Overview page exactly, which is a good sign of model consistency across the report. Revenue is geographically concentrated in North America, consistent with a US card-issuer dataset, though the map's default zoom level (showing the whole world) currently obscures rather than highlights that finding. Two issues need fixing before this page is considered finished: the second "Success Rate" KPI card is mislabeled and actually displays the Failure Rate, and the Monthly Transactions Trend chart shows the same unexplained "(Blank)"-spike-then-flat pattern seen on the Executive Overview page, which should be root-caused as a data-model issue rather than treated as two separate one-off glitches.

## Part 5 — Business Recommendations

1. **Relabel the second KPI card from "Success Rate" to "Failure Rate"** — a one-line fix that currently undermines trust in the whole page at first glance.
2. **Prioritize a fix for Insufficient-Balance and Bad-PIN failures specifically**, since they're the two leading named causes in both the full-history and 2011 breakdowns.
3. **Build a compound-failure-aware root-cause view** (parse multi-reason error strings into individual flags) rather than treating each unique string as its own category — this will change the true ranking of failure causes.
4. **Re-zoom the Revenue by State map to North America by default**, since that's where 100% of the visible revenue sits — the current world view wastes the map's most valuable screen space.
5. **Root-cause and fix the "(Blank)" trend-chart anomaly** shared with Page 1 — likely a single underlying data-model fix that resolves both pages at once.
6. **Add a Failed-Transaction-rate trend line over time**, not just a point-in-time KPI, so ops can see whether reliability is improving or degrading.
7. **Cross-reference failure rate against payment channel (`use_chip`)** — the "Interactive Filters" slicer already includes `use_chip`, so this analysis is one click away from being built into the page directly as a chart.

## Part 6 — Dashboard Design Review

| Category | Score /10 | Rationale |
|---|---|---|
| Layout | 6 | Reasonable grid, but the two Success/Failure Rate cards flanking a filter box in the middle is a slightly unusual arrangement compared to Pages 1–2's clean top-row-of-KPIs pattern |
| Color usage | 5 | Green KPI cards read as "good" universally, which is actively wrong for the mislabeled Failure Rate card once relabeled — color semantics need to change with the label fix |
| KPI placement | 5 | Splitting the two rate KPIs to opposite ends of the row, with Total/Average/Successful/Failed in between, is harder to scan than grouping all rate metrics together |
| Chart selection | 7 | Map, ranked bar, line trend, and 100%-stacked bar are all appropriate choices for their respective questions |
| Readability | 5 | Same Average Transaction overflow issue as Page 1; the world-zoomed map reads as mostly empty space |
| White space | 6 | Comparable to the other two pages |
| Consistency | 4 | **Visibly different visual theme from Pages 1–2** — white background instead of green, different title font/weight, no subtitle, no dynamic title — reads as a different report bolted on rather than page 3 of the same dashboard |
| Visual hierarchy | 6 | KPI-then-charts ordering is sound; undermined by the mislabeled card competing for attention |
| Accessibility | 5 | Green-for-both-good-and-bad-metric coloring is a real accessibility/comprehension risk, independent of colorblindness |
| User experience | 6 | Slicer and drill behavior work correctly and consistently with the other two pages; the visual-theme mismatch is the main UX complaint |

## Part 7 — Improvement Suggestions

- **Additional KPIs:** Failure Rate Trend (sparkline), Top Failure Reason (dynamic text measure), Revenue at Risk (sum of amount on failed transactions).
- **Better visuals:** default the state map to a North-America extent; consider a small-multiples view of error reasons by year instead of a single 100%-stacked bar.
- **Better DAX measures:** a measure that decomposes compound `errors` strings into individual boolean flags (e.g., `HasInsufficientBalance`, `HasBadPIN`) to support accurate failure-mode ranking.
- **Better filters/slicers:** the combined "Year, Month Name, merchant_state, use_chip" slicer is powerful but dense — consider breaking `merchant_state` and `use_chip` into their own compact slicers so a user isn't hunting through one long hierarchy for an unrelated field.
- **Drill-through:** from any Transaction Error Distribution segment, drill through to the underlying failed-transaction list (user, card, merchant, amount).
- **Tooltips:** add the specific failure count alongside the percentage on the error-distribution bar.
- **Bookmarks:** a "This Year" vs. "All Time" bookmark toggle for quick exec switching.
- **Dynamic titles:** bring this page in line with Page 1's dynamic, filter-aware title treatment.
- **Consistency fix:** apply Pages 1–2's green background theme, title styling, and subtitle pattern to this page so the report reads as one cohesive product.

---

# Part 9 — Interview Preparation (Whole Dashboard)

## 10 Interview Questions & Model Answers

**1. Walk me through this dashboard — what does it do?**
It's a three-page Power BI report on top of a PostgreSQL star schema covering ~13 million card transactions: an Executive Overview (revenue, volume, category and payment-channel mix), a Customer Analytics page (demographic and value segmentation), and a Transaction Analytics page (success/failure rate, failure reasons, geographic spread). Each page is independently filterable and the KPIs update consistently across every visual on the page.

**2. Why did you split this into three pages instead of one page?**
Different stakeholders ask different questions of the same data. An executive wants revenue and trend; a marketer wants customer segments; an operations/risk team wants success rate and failure reasons. Splitting by audience keeps each page focused instead of forcing one crowded page to serve three very different reading habits.

**3. What's the single most important number on this dashboard, and why?**
Total Revenue (571.84M) on the Executive Overview is the headline, but I'd actually pair it with Success Rate (98%) from the Transaction page — revenue without knowing what fraction of attempted transactions actually completed is an incomplete picture of platform health.

**4. I noticed one of your KPI cards is mislabeled — what happened, and how would you fix it?**
The second "Success Rate" card on the Transaction Analytics page actually displays the Failure Rate — the math is correct (it's the complement of the real success rate), but the card title wasn't updated after it was likely duplicated from the first card. It's a one-line label fix, and I'd also flip its color semantics, since green currently implies "good" for a metric where lower is better.

**5. Your Monthly Revenue Trend chart shows a strange spike — can you explain that?**
That's a real, visible data-quality issue I'd flag rather than hide: there's a large value sitting in a "(Blank)" date bucket, which flattens the rest of the real, dated months into a near-zero-looking line. The likely causes are a NULL/unparsed date on a subset of transactions, or a fan-out join in the report's data model. I'd trace it back to the `txn_date` handling in the fact table and the relationship cardinality in the Power BI model before trusting this chart for trend reporting.

**6. How does your data model support this dashboard — what's underneath it?**
A star schema: `fact_transactions` at transaction grain, joined to `dim_users`, `dim_cards`, `dim_merchant`, and `dim_mcc`. The dashboard's slicers and cross-filtering rely on those relationships being clean 1:many joins — the merchant dimension in particular needed a surrogate key because the natural merchant id repeats across locations, which is exactly the kind of thing that causes fan-out bugs like the one in question 5 if it's ever gotten wrong.

**7. How would you improve this dashboard if you had another week?**
Three things in priority order: root-cause the trend-chart data issue since it affects two pages, fix the KPI label and formatting issues (Failure Rate mislabel, Average Transaction text overflow), and bring the Transaction Analytics page's visual theme in line with the other two pages so the report reads as one cohesive product instead of three separately-styled pages.

**8. What business decision would you actually make from the Customer Analytics page?**
The 45-54 age band is the highest-revenue cohort, ahead of 65+, and Mastercard/Visa dominate card-brand revenue over Amex/Discover. I'd prioritize a retention offer aimed at the 45-54 segment specifically, since it's both the largest value pool and one that's easy to overlook in favor of flashier younger-demographic campaigns.

**9. Why is the "Income vs Revenue" scatter plot not showing a clear relationship?**
Visually, all the points sit at roughly the same height regardless of income, which shouldn't happen if the Y-axis is genuinely bound to income. The tooltip data itself is correct, so I'd check the Y-axis field binding and its aggregation before drawing any conclusion from that chart — it's a chart-configuration issue to fix, not evidence that income and spend are uncorrelated.

**10. How do success rate and failure reasons tie back to a business action?**
Insufficient Balance and Bad PIN are the two leading failure causes. Insufficient Balance points toward a customer-facing fix (e.g., low-balance alerts before a decline), while Bad PIN points toward a UX/authentication fix at the terminal or app level. Those are two different owning teams, which is exactly why breaking failure reasons out explicitly — rather than reporting one blended failure rate — is valuable.

## Common Mistakes to Avoid When Explaining This Dashboard

- Don't claim the Monthly Revenue Trend chart shows "steady growth" or any real trend — as built, it doesn't, and an interviewer who's looked closely will catch that immediately.
- Don't call both Success/Failure Rate cards "Success Rate" out loud without noting the label bug — it signals you didn't actually look at your own dashboard.
- Don't present the Income vs Revenue scatter as evidence of a correlation (or lack of one) — the chart isn't currently rendering correctly enough to support that claim either way.
- Don't say "the map shows global revenue" — it shows North-America-only revenue at a wasteful world-zoom level; be precise about what's actually there.
- Don't frame this as a "Personal Finance / Budget Intelligence" tool in an interview — be ready to explain the scope pivot (see [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md)) if asked why the dashboard is titled "Personal Finance Analytics" but only reports card-transaction and merchant metrics, with no income, savings, or budget data anywhere in it.

## 2-Minute Presentation Script

> *"This is a three-page Power BI dashboard sitting on top of a PostgreSQL star-schema warehouse of about 13 million credit-card transactions. Page one is the executive view — total revenue, transaction volume, customer and card counts, a monthly trend, and where revenue concentrates by merchant category and payment channel. Money Transfer is consistently the top category, and interestingly, chip-card usage is essentially zero in the earliest years of the data and grows over time, which lines up with the real-world EMV rollout — a good sanity check that the data behaves the way history says it should.*
>
> *Page two turns the same revenue number into a customer lens — age, gender, income, credit score, and card brand — and the standout finding is that the 45-to-54 age band is the highest-revenue cohort, ahead of even the 65-plus group, with Mastercard and Visa dominating card-brand revenue over Amex and Discover.*
>
> *Page three is the operational view: a 98% transaction success rate, with Insufficient Balance and Bad PIN as the two leading failure reasons, plus a geographic revenue map.*
>
> *I'll be upfront about two things I found while reviewing my own work: the Monthly Revenue Trend chart currently has a data-model issue — a disproportionate value sitting in a blank date bucket that flattens the rest of the real trend — and one KPI card on the operations page is mislabeled, showing the failure rate under a 'Success Rate' title. Both are one-to-a-few-line fixes, and calling them out unprompted is exactly the kind of review discipline I'd want to bring to a production dashboard before it reaches an actual stakeholder."*

---

## Cross-Page Design Score Summary

| Category | Page 1 | Page 2 | Page 3 |
|---|---:|---:|---:|
| Layout | 7 | 7 | 6 |
| Color usage | 6 | 6 | 5 |
| KPI placement | 7 | 8 | 5 |
| Chart selection | 8 | 5 | 7 |
| Readability | 5 | 6 | 5 |
| White space | 7 | 7 | 6 |
| Consistency | 8 | 8 | 4 |
| Visual hierarchy | 7 | 6 | 6 |
| Accessibility | 5 | 5 | 5 |
| User experience | 6 | 7 | 6 |
| **Average** | **6.6** | **6.5** | **5.5** |

The recurring themes across all three pages: strong slicer/drill-down interactivity and consistent cross-filtering (a genuine strength), against three concrete, fixable defects — the shared "(Blank)" trend-chart anomaly, the Average Transaction card text overflow, and Page 3's visual-theme mismatch with Pages 1–2.
