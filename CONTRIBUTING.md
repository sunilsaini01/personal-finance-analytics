# Contributing

Thanks for your interest in this project. It started as a solo portfolio build, but issues and pull requests are welcome — whether that's a bug report, a documentation fix, or a proposed enhancement.

## Before You Start

- **Read [`docs/00_PRD_Scope_Addendum.md`](docs/00_PRD_Scope_Addendum.md) first.** This project was deliberately re-scoped around what its source dataset (credit-card transactions only — no income, budget, or savings data) can actually support. Proposals that require fabricating business data the dataset doesn't have will be declined for that reason, not because the idea is bad.
- **Check [`docs/17_Documentation_Audit.md`](docs/17_Documentation_Audit.md)** for the current known-issues and prioritized action list before opening a new issue — your item may already be tracked.

## How to Contribute

1. **Open an issue first** for anything beyond a trivial fix (typo, broken link) — this avoids duplicate work and lets us agree on approach before you write code.
2. **Fork the repo and create a branch** named descriptively, e.g. `fix/audit-log-fk` or `docs/clarify-etl-join`.
3. **Follow the existing conventions:**
   - SQL: `snake_case`, files numbered by pipeline stage within their folder (see [`06_ETL_Process.md`](docs/06_ETL_Process.md) and [`sql/`](sql/)).
   - Docs: Markdown, numbered sequentially in `docs/`, cross-referenced with relative links.
   - Every fact-table change should restate its grain (see [`14_ER_Diagram_Architecture.md`](docs/14_ER_Diagram_Architecture.md)) — this project treats "grain agreed before SQL is written" as a hard rule, not a suggestion.
4. **Validate SQL changes** against `sql/09_testing/` before submitting — row-count, duplicate-key, and orphan-record checks should still pass.
5. **Update documentation alongside code.** A schema change without a corresponding data-dictionary/ER-diagram update will be asked to add one before merge.
6. **Open a pull request** using the template in `.github/PULL_REQUEST_TEMPLATE.md`, describing what changed and why.

## Reporting Bugs

Open an issue using the bug report template (`.github/ISSUE_TEMPLATE/bug_report.md`). Include the affected file(s), what you expected, and what actually happened. If it's a data-quality issue, a minimal reproducing query is the fastest way to get it fixed.

## Proposing Enhancements

Open an issue using the feature request template (`.github/ISSUE_TEMPLATE/feature_request.md`). Explain the business question it answers and, ideally, whether the current dataset (see [`docs/03_Dataset_Description.md`](docs/03_Dataset_Description.md)) can actually support it.

## Code of Conduct

This project follows [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md). Participation implies agreement to it.

## Questions

Open an issue with the `question` label, or start a discussion if GitHub Discussions is enabled on this repository.
