# Dagster
FROM python:3.10-slim AS dagster

RUN apt-get update && apt-get upgrade -yqq
RUN apt-get install git -y
ENV DAGSTER_HOME=/opt/dagster/dagster_home/
RUN mkdir -p $DAGSTER_HOME
WORKDIR $DAGSTER_HOME
COPY dagster.yaml workspace.yaml $DAGSTER_HOME
# RUN git clone https://github.com/dagster-io/dagster.git
RUN pip install \
    dagster \
    dagster-aws \
    dagster-postgres

# Webserver
FROM dagster AS webserver
RUN pip install \
    dagster-webserver \
    dagster-graphql

# Code location
FROM dagster AS user_code

RUN pip install dagster-duckdb
RUN pip install duckdb
RUN pip install plotly
RUN pip install geopandas

