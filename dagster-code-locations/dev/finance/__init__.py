from dagster import graph, op, schedule


@op
def hello():
    return 1


@op
def goodbye(foo):
    if foo != 1:
        raise Exception("Bad io manager")
    return foo * 2


@graph
def my_graph():
    goodbye(hello())


my_job = my_graph.to_job(name="my_job")


@schedule(cron_schedule="* * * * *", job=my_job, execution_timezone="US/Central")
def my_schedule(_context):
    return {}
