# football-analytics-dbt

Football analytics built on StatsBomb open data. Raw JSON is loaded into DuckDB, modelled with dbt (staging, intermediate, marts, tests) and shown in an Evidence dashboard.

Data: [StatsBomb Open Data](https://github.com/statsbomb/open-data). Provided by StatsBomb for research and non-commercial use. Any analysis published from it must credit StatsBomb and use their logo (see their [media pack](https://statsbomb.com/media-pack/)).

## Status

Milestone 1 of 5: loader and project skeleton. No models yet.

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
- Evidence for the dashboard (milestone 4)
- GitHub Actions for CI

## Layout

```
data_load/      Python loader: StatsBomb JSON -> DuckDB raw schema
dbt/            dbt project (sources, models, tests)
.github/        CI workflow
```

## Run it

Requires Python 3.10+.

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
make load        # downloads the FIFA World Cup 2022 files into data/raw and builds warehouse.duckdb
make check       # dbt debug + dbt parse
```

Pick another competition with `COMPETITION_ID` and `SEASON_ID`. The list is in `competitions.json` in the StatsBomb repo.

```bash
COMPETITION_ID=55 SEASON_ID=43 make load   # UEFA Euro 2020
```

## Raw tables

`raw.competitions`, `raw.matches`, `raw.lineups`, `raw.events`. The loader keeps the JSON structure as is and adds the source file name. Cleaning happens in dbt, not in the loader.

## Data credit

Data from StatsBomb. See the link at the top for the terms.
