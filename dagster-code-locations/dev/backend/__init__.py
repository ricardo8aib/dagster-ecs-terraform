from dagster import asset, Definitions


@asset
def backend_dummy_asset():
    return "Hello, Dagster!"


defs = Definitions(
    assets=[backend_dummy_asset],
)
