# football-analytics-dbt

Football analytics built on StatsBomb open data. Raw JSON is loaded into DuckDB, modelled with dbt (staging, intermediate, marts, tests) and shown in an Evidence dashboard.

Data: [StatsBomb Open Data](https://github.com/statsbomb/open-data). Provided by StatsBomb for research and non-commercial use. Any analysis published from it must credit StatsBomb and use their logo (see their [media pack](https://statsbomb.com/media-pack/)).

## Status

Milestone 2 of 5: staging models. The loader, dbt skeleton and CI are done. Staging covers matches, lineups and events.

| # | Milestone | State |
|---|---|---|
| 1 | Loader, dbt skeleton, CI | done |
| 2 | Staging and intermediate models | in progress (stg_matches, stg_lineups, stg_events done) |
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
make load        # downloads the UEFA Euro 2024 files into data/raw and builds warehouse.duckdb
make check       # dbt debug + dbt parse
```

Pick another competition with `COMPETITION_ID` and `SEASON_ID`. The list is in `competitions.json` in the StatsBomb repo.

```bash
COMPETITION_ID=43 SEASON_ID=106 make load   # FIFA World Cup 2022
```

Switching competitions re-downloads only what is missing. The loader removes cached event and lineup files from other competitions first, so the raw tables always hold a single competition.

## Raw tables

`raw.competitions`, `raw.matches`, `raw.lineups`, `raw.events`. The loader keeps the JSON structure as is and adds the source file name. Cleaning happens in dbt, not in the loader.

## Models

Staging models in `dbt/models/staging/`, each with tests in a matching `.yml` file:

- `stg_matches`: one row per match
- `stg_lineups`: one row per player per team per match
- `stg_events`: one row per match event

Intermediate models, marts and the dashboard are not built yet.

## Data credit

Data from StatsBomb. See the link at the top for the terms.
