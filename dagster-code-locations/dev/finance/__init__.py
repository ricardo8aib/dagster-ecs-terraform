from dagster import asset, Definitions


@asset
def finance_dummy_asset():
    return "Hello, Dagster!"


defs = Definitions(
    assets=[finance_dummy_asset],
)
