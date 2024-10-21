from dagster import asset, Definitions


@asset
def marketing_dummy_asset():
    return "Hello, Dagster!"


defs = Definitions(
    assets=[marketing_dummy_asset],
)
