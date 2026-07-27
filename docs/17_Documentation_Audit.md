# Documentation Quality Review

# Card Transaction & Merchant Analytics

---

## Purpose

A professional documentation audit of this repository as it stands after the "Card Transaction & Merchant Analytics" repositioning — what's fixed, what's still inconsistent, and what to do next, in priority order. This audit is written to be re-run mentally by anyone reviewing the repo fresh; it names specific files rather than speaking in generalities.

## What This Repositioning Fixed

- Every active doc (`docs/01`–`13`, `docs/README.md`, root `README.md`, `dashboard/README.md`) now titles the project "Card Transaction & Merchant Analytics" instead of "Personal Finance Analytics & Budget Intelligence System."
- `05_Database_Design.md` and `11_Star_Schema.md` no longer describe `stg_transactions` as the fact table, and both now include `dim_merchant` and `audit_log`, which were previously omitted entirely.
- `04_Data_Dictionary.md` now documents all nine tables (including `dim_merchant` and `audit_log`, previously missing) with columns matching the actual DDL.
- `12_Query_Optimization.md` no longer claims "indexes were not created in this project" — `sql/04_indexes/` demonstrably contains them, and the doc now describes the real indexing strategy.
- `06_ETL_Process.md` no longer references a fictional `02_cleaning/`/`03_dimension_loading/`/`04_validation/` folder structure — it now matches the real `sql/` layout.
- `07_SQL_Analysis.md`, `08_Business_Insights.md`, `02_Business_Requirements.md`, and `09_KPI_Definitions.md` no longer use "income," "savings rate," "budget planning," or "financial health score" language — reframed consistently around *spend* and *net spend*.

## Missing Sections (Found, Now Added)

| Gap | Resolution |
|---|---|
| No dedicated portfolio-positioning guidance | Added [`16_Portfolio_Positioning.md`](16_Portfolio_Positioning.md) |
| No consolidated technical-validation reference (row-count/FK/integrity checks were scattered across SQL comments only) | Added [`18_Technical_Validation.md`](18_Technical_Validation.md) |
| No formal scope section (In Scope / Out of Scope / Assumptions / Constraints / Risks / Future Enhancements) | Folded into [`02_Business_Requirements.md §4`](02_Business_Requirements.md) |
| No user stories or business rules reflecting the corrected scope | Added to [`02_Business_Requirements.md §8–9`](02_Business_Requirements.md) |

## Redundant Sections (Identified, Not Merged)

- **`10_Project_Architecture.md` and `14_ER_Diagram_Architecture.md` cover overlapping ground** by design — `10` is kept as a short, high-level summary; `14` is the authoritative deep-dive (ER diagram, DBML, every design decision's rationale). Each now explicitly says which one wins on conflict, so the redundancy is intentional and signposted rather than accidental.
- **`13_Conclusion.md` and `16_Portfolio_Positioning.md` both touch "why this project is valuable."** Kept separate deliberately: `13` is a project-internal summary (what was built, what was learned); `16` is external-facing (how to pitch it to a recruiter/interviewer). Worth merging only if repo size becomes a concern — not recommended otherwise, since they serve different readers.

## Inconsistent Terminology (Checked)

- **"Cash Flow" vs. "Net Spend":** now consistently reframed as *net spend* (spend minus refunds) everywhere it's discussed as a KPI, with an explicit note in [`09_KPI_Definitions.md §11`](09_KPI_Definitions.md#11-net-spend) that this is not an income-based cash-flow measure. `sql/10_business_analytics/05_cashflow_analysis.sql` keeps its original filename for traceability to the PRD's original business question — this is called out explicitly in [`07_SQL_Analysis.md`](07_SQL_Analysis.md) so the filename doesn't read as a contradiction.
- **"Client" vs. "User":** staging tables use `client_id` (source-file naming); the star schema uses `user_id`. This is not an inconsistency to fix — it's the documented staging→dimension rename, called out in [`04_Data_Dictionary.md`](04_Data_Dictionary.md).
- **Not yet touched:** SQL file header comments (e.g., `-- Personal Finance Analytics` in `sql/01_ddl/01_staging_tables.sql`, `sql/03_load/02_load_transactions.sql`, and several others) still reference the old project name. This repositioning was scoped to documentation, not source-code comments — see Action Plan item 2.

## Incorrect Assumptions (Found Elsewhere in the Repo, Not Fixed by This Pass)

- **`folder_structure.txt`** (repo root) is a stale snapshot from an earlier project layout — it references `docs/business_requirements.md`, `sql/02_cleaning/`, `sql/04_analysis/`, and other paths that no longer exist. It is not linked from any active documentation, but a reviewer who opens it directly will get a wrong picture of the repo. See Action Plan item 1.
- **Numbering collision:** `sql/10_business_analytics/` and `sql/10_security/` both use the `10_` prefix. Functionally harmless (folder names don't collide), but it breaks the otherwise-consistent "one number per pipeline stage" convention used everywhere else in `sql/`. See Action Plan item 3.
- **`dashboard/README.md`'s known-issues list** (trend-chart anomaly, mislabeled Failure Rate card, Average Transaction overflow) is accurate as of this writing but describes the `.pbix` file's *current* state — it will go stale the moment those are fixed without a corresponding doc update. Flagged so whoever fixes the dashboard remembers to update that section too.

## Opportunities for Improvement

- **`data/raw/train_fraud_labels.json` and `data/raw/gdp_by_country_2026_imf.csv` are not referenced by any load script** but exist in the source data. Both are called out as future-enhancement material in [`13_Conclusion.md`](13_Conclusion.md) and the root `README.md`, but neither has a committed plan — worth deciding explicitly (build it, or note in the audit that it's intentionally unused) rather than leaving it ambiguous indefinitely.
- **`docs/Archive/`** contains 35 historical documents plus the original PRD, all correctly frozen and marked as superseded — but the archive's own internal index (in `docs/README.md`) doesn't distinguish "superseded by a specific numbered doc" from "superseded by the repositioning generally." A one-line mapping (old doc → its replacement, where one exists) would close that out.
- **No automated documentation-consistency check.** This audit was performed by direct reading; a lightweight script that greps for banned terms ("savings rate," "budget adherence," "financial health score," "Personal Finance Analytics & Budget Intelligence") across `docs/` and fails CI on a hit would keep this repositioning from silently regressing as new docs are added.

## Prioritized Action Plan

**P1 — Do next:**
1. Delete or regenerate `folder_structure.txt` — it actively misleads a reviewer who opens it and is redundant with the accurate structure in the root `README.md §5`.
2. Update the project-name comment header in the SQL files that still say "Personal Finance Analytics" (a mechanical find-and-replace across `sql/*.sql` header comments) — low risk, closes the last visible trace of the old name.
3. Resolve the `sql/10_business_analytics/` vs. `sql/10_security/` numbering collision (rename one, e.g. `sql/12_security/`) for consistency with the rest of the pipeline's numbering convention.

**P2 — Do before the next portfolio review:**
4. Fix the three dashboard defects tracked in [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md) and [`dashboard/README.md`](../dashboard/README.md), then update both docs' known-issues sections to reflect the fix.
5. Add the one-line "banned terminology" CI check described above.
6. Add a superseded-doc mapping table to `docs/README.md`'s Archive section.

**P3 — Nice to have:**
7. Decide and document an explicit stance on `train_fraud_labels.json` and `gdp_by_country_2026_imf.csv` (build against them, or mark them formally out of scope rather than implicitly unused).
8. Consider whether `10_Project_Architecture.md` should eventually be trimmed to a pure summary-with-links, once `14_ER_Diagram_Architecture.md` has had a chance to stabilize as the sole deep-dive.

## Conclusion

The documentation set is now internally consistent on project name, scope, and terminology, and every previously-identified factual inaccuracy in the technical docs (wrong fact table, missing tables, missing indexes, wrong folder structure) has been corrected. What remains — stale non-doc artifacts, SQL comment headers, a folder-numbering collision, and the live dashboard defects — is deliberately left as a named, prioritized action list rather than silently fixed, so the next person to touch this repo (including a future version of the author) knows exactly what's still open and why.
