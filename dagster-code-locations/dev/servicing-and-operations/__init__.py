from dagster import asset, Definitions


@asset
def servicing_dummy_asset():
    return "Hello, Dagster!"


defs = Definitions(
    assets=[servicing_dummy_asset],
)
