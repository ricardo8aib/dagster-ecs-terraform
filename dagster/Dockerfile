# Dagster
FROM python:3.10-slim AS dagster

RUN apt-get update && apt-get upgrade -yqq
RUN apt-get install git -y
ENV DAGSTER_HOME=/opt/dagster/dagster_home/
RUN mkdir -p $DAGSTER_HOME
WORKDIR $DAGSTER_HOME
COPY dagster.yaml workspace.yaml $DAGSTER_HOME
RUN pip install \
    dagster \
    dagster-postgres \
    dagster-aws 

# Webserver
FROM dagster AS webserver
RUN pip install \
    dagster-webserver \
    dagster-graphql

# Data Engineering Backend
FROM dagster AS backend_dev
RUN pip install dagster-dbt
RUN pip install dagster-slack
RUN pip install dagster-pandas
RUN pip install dagster-snowflake
RUN pip install dagster-embedded-elt


# Marketing
FROM dagster AS marketing_dev
RUN pip install dagster-dbt

# Finance
FROM dagster AS finance_dev
RUN pip install dagster-dbt

# Fraud
FROM dagster AS fraud_dev
RUN pip install dagster-dbt

# Servicing & Operations
FROM dagster AS servicing_dev
RUN pip install dagster-dbt
