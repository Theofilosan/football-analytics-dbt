.PHONY: load check clean

load:
	python data_load/load_statsbomb.py

check:
	cd dbt && DBT_PROFILES_DIR=. dbt debug && DBT_PROFILES_DIR=. dbt parse

clean:
	rm -rf data warehouse.duckdb dbt/target dbt/logs
