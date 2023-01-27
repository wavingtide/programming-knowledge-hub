# dbt
*(refer to [dbt documentation](https://docs.getdbt.com/))

dbt has two products:
- dbt Core: An open-source tool that enables data teams to transform data using analytics engineering best practices
- dbt Cloud: The fastest and most reliable way to deploy dbt which support developing, testing, scheduling, and investigating data models all in one web-based UI.

# Table of Contents
- [dbt](#dbt)
- [Table of Contents](#table-of-contents)
- [Popular Supported Data Platform](#popular-supported-data-platform)
- [Installation](#installation)
  - [Install with Homebrew](#install-with-homebrew)
  - [Install with pip](#install-with-pip)
  - [Install with Docker](#install-with-docker)
  - [Install from Source](#install-from-source)
- [dbt Core](#dbt-core)

# Popular Supported Data Platform
- Azure Synapse
- BigQuery
- Databricks
- Postgres
- Redshift
- Snowflake
- Spark


# Installation
Once you know the adapter you are using, you can install it as `dbt-<adapter>` (example: `dbt-postgres`)
## Install with Homebrew
Homebrew support the four oldest and most popular adapter plugins: Postgres, Redshift, Snowflake and BigQuery
``` shell
brew update
brew install git
brew tap dbt-labs/dbt
```

``` shell
brew install dbt-postgres
```


## Install with pip
``` shell
pip install dbt-postgres
```

## Install with Docker


## Install from Source

# dbt Core

