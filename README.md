# football-analytics-dbt

Football analytics built on StatsBomb open data. Raw JSON is loaded into DuckDB, modelled with dbt (staging, intermediate, marts, tests) and shown in an Evidence dashboard.

Data: [StatsBomb Open Data](https://github.com/statsbomb/open-data). Provided by StatsBomb for research and non-commercial use. Any analysis published from it must credit StatsBomb and use their logo (see their [media pack](https://statsbomb.com/media-pack/)).

## Status

| # | Milestone | State |
|---|---|---|
| 1 | Loader, dbt skeleton, CI | in progress |
| 2 | Staging and intermediate models | todo |
| 3 | Marts and tests | todo |
| 4 | Evidence dashboard on GitHub Pages | todo |
| 5 | Docs and README polish | todo |

## Stack

- DuckDB as the warehouse (single local file)
- dbt Core with the dbt-duckdb adapter
- Evidence for the dashboard
- GitHub Actions for CI
