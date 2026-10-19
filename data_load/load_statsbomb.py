"""Download one StatsBomb competition season and load it into DuckDB.

Raw JSON is kept as is. The only column added is the source file name.
Usage:
    python data_load/load_statsbomb.py
    COMPETITION_ID=55 SEASON_ID=43 python data_load/load_statsbomb.py
"""
import json
import os
from pathlib import Path

import duckdb
import requests

BASE = "https://raw.githubusercontent.com/statsbomb/open-data/master/data"
COMPETITION_ID = int(os.environ.get("COMPETITION_ID", 43))  # FIFA World Cup
SEASON_ID = int(os.environ.get("SEASON_ID", 106))  # 2022
ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"
DB = ROOT / "warehouse.duckdb"


def fetch(path: str, dest: Path) -> None:
    if dest.exists():
        return
    dest.parent.mkdir(parents=True, exist_ok=True)
    r = requests.get(f"{BASE}/{path}", timeout=60)
    r.raise_for_status()
    dest.write_bytes(r.content)


def main() -> None:
    fetch("competitions.json", RAW / "competitions.json")
    matches_file = RAW / "matches" / f"{COMPETITION_ID}_{SEASON_ID}.json"
    fetch(f"matches/{COMPETITION_ID}/{SEASON_ID}.json", matches_file)

    match_ids = [m["match_id"] for m in json.loads(matches_file.read_text())]
    for mid in match_ids:
        fetch(f"lineups/{mid}.json", RAW / "lineups" / f"{mid}.json")
        fetch(f"events/{mid}.json", RAW / "events" / f"{mid}.json")
    print(f"downloaded {len(match_ids)} matches")

    con = duckdb.connect(str(DB))
    con.execute("create schema if not exists raw")
    sources = {
        "competitions": RAW / "competitions.json",
        "matches": matches_file,
    }
    for name, path in sources.items():
        con.execute(
            f"create or replace table raw.{name} as "
            f"select *, filename as _source_file from read_json_auto('{path}', filename=true)"
        )
    for name in ("lineups", "events"):
        con.execute(
            f"create or replace table raw.{name} as "
            f"select *, filename as _source_file "
            f"from read_json_auto('{RAW / name}/*.json', filename=true, union_by_name=true, maximum_object_size=104857600)"
        )
    for name in ("competitions", "matches", "lineups", "events"):
        n = con.execute(f"select count(*) from raw.{name}").fetchone()[0]
        print(f"raw.{name}: {n} rows")


if __name__ == "__main__":
    main()
