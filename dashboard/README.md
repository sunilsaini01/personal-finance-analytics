# Dashboard

# Card Transaction & Merchant Analytics

`Personal_Finance_Analytics.pbix` (filename kept from before the project's
rename to "Card Transaction & Merchant Analytics" — see
[`../docs/00_PRD_Scope_Addendum.md`](../docs/00_PRD_Scope_Addendum.md)) is the
Power BI Desktop file for this project. It connects to the
`finance_analytics` PostgreSQL database built by the scripts in
[`/sql`](../sql).

## Getting the .pbix file

`Personal_Finance_Analytics.pbix` is **317MB** — over GitHub's 100MB hard
per-file limit — so it is excluded from git (`*.pbix` in `.gitignore`) and
is not part of this repository's history. The screenshots in
[`../screenshots/`](../screenshots/) and the write-up in
[`../docs/15_Dashboard_Documentation.md`](../docs/15_Dashboard_Documentation.md)
cover what the dashboard looks like and how it behaves without needing the
file itself.

## Status

- [x] `.pbix` file built
- [x] Screenshots — see [`../screenshots/`](../screenshots/) (one default view + one filtered/drilled view per page)
- [x] Page-by-page write-up — see [`../docs/15_Dashboard_Documentation.md`](../docs/15_Dashboard_Documentation.md)

## Known issues (flagged in the write-up, not yet fixed in the .pbix)

- Monthly Revenue Trend (page 1) and Monthly Transactions Trend (page 3) both show a large value sitting in a `(Blank)` date bucket, flattening the rest of the real trend — needs root-causing in the data model (likely a NULL/unparsed `txn_date` or a fan-out join), not just a formatting fix.
- The second "Success Rate" KPI card on the Transaction Analytics page is mislabeled — it actually displays the Failure Rate.
- The Average Transaction KPI card overflows its card (`$42.9760...`) on both the Executive Overview and Transaction Analytics pages.
- The "Income vs Revenue" scatter plot on the Customer Analytics page doesn't show vertical spread by income — likely a Y-axis field binding issue, not a data problem.
- Transaction Analytics page uses a different visual theme (white background, different title styling) than the other two pages.

## To open

1. Run the ETL pipeline in [`/sql`](../sql) (`01_ddl` → `03_load`) against a
   local PostgreSQL instance named `finance_analytics`.
2. Open `Personal_Finance_Analytics.pbix` in Power BI Desktop.
3. Update the data source credentials/connection string if your PostgreSQL
   host, port, or database name differ from the defaults.

## Known follow-up

The underlying SQL and documentation have been corrected to stop mislabeling
card spend as "income"/"savings" (this dataset has no salary/income stream —
see [`docs/09_KPI_Definitions.md`](../docs/09_KPI_Definitions.md)). The
`.pbix` file itself is a binary Power BI artifact and has **not** been
verified against this change — if any visual or measure inside it still
reads "Income" or "Savings Rate," relabel it to match the corrected "Spend" /
"Net Spend" framing before treating the dashboard as final.
