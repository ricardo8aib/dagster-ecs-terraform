from dagster_duckdb import DuckDBResource

database_resource = DuckDBResource(
    database="file.duckdb"
)
