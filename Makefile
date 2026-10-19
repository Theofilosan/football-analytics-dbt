.PHONY: load clean

load:
	python data_load/load_statsbomb.py

clean:
	rm -rf data warehouse.duckdb
