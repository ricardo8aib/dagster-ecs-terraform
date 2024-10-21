from dagster import asset, Definitions


@asset
def fraud_dummy_asset():
    return "Hello, Dagster!"


defs = Definitions(
    assets=[fraud_dummy_asset],
)
