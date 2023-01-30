# dbt
*(refer to [dbt documentation](https://docs.getdbt.com/))*  
*(based on dbt version 1.4.1)*

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
- [Getting started with dbt Core](#getting-started-with-dbt-core)

# Popular Supported Data Platform
- Azure Synapse
- BigQuery
- Databricks
- Postgres
- Redshift
- Snowflake
- Spark


# Installation
All adapters are build on top of `dbt-core`.

Once you know the adapter you are using, you can install it as `dbt-<adapter>` (example: `dbt-postgres`, this will install `dbt-core` and `dbt-postgres`.).

The [documentation](https://docs.getdbt.com/docs/get-started/installation) has roughly stated the considerations to choose a certain installation method over the other.
1. If you are using Mac, you want something convenient without too much control, and you are using the 4 oldest and most popular adapters, install with homebrew.
2. If you are using Linux or Windows and developing locally, install with pip.
3. If you are using dbt in production, use a prebuilt Docker image.
4. If you want the latest code or want to install dbt from a specific commit, likely as a contributor, install from source.

It also states the dependencies required for each operating system before installing dbt. Most of the time, Python and Git are required.

## Install with Homebrew
Homebrew supports the four oldest and most popular adapter plugins: Postgres, Redshift, Snowflake and BigQuery.

Run the one-time setup.
``` shell
brew update
brew install git
brew tap dbt-labs/dbt
```

``` shell
brew install dbt-postgres
```

## Install with pip
You might need to install Python and Git before installing dbt.

``` shell
pip install dbt-postgres
```

## Install with Docker
Official dbt docker images are hosted as packages in `dbt-labs` Github organization ([link](https://github.com/orgs/dbt-labs/packages?visibility=public)).

Install an image using `docker pull`
``` shell
docker pull ghcr.io/dbt-labs/<db_adapter_name>:<version_tag>
```

Example:
``` shell
docker pull ghcr.io/dbt-labs/dbt-bigquery:1.3.latest
```

To run a dbt Docker image
``` shell
docker run \
--network=host \
--mount type=bind,source=path/to/project,target=/usr/app \
--mount type=bind,source=path/to/profiles.yml,target=/root/.dbt/ \
<dbt_image_name> \
ls
```
The `ENTRYPOINT` for dbt Docker images is the command `dbt`. You can bind-mount your project to /usr/app and use dbt as normal.

## Install from Source
Run the following will install `dbt-core` and `dbt-postgres`.
``` shell
git clone https://github.com/dbt-labs/dbt-core.git
cd dbt-core
pip install -r requirements.txt
```

To install in an editable mode, use
``` shell
pip install -e editable-requirements.txt
```

To install a particular adapter plugins, locate its source repository before cloning and installing.
``` shell
git clone https://github.com/dbt-labs/dbt-redshift.git
cd dbt-redshift
pip install .
```

# Getting started with dbt Core
Prerequisites: 
1. `pip install dbt-bigquery`
2. Create GCP account and [Setting up (in BigQuery)](https://docs.getdbt.com/docs/get-started/getting-started/getting-set-up/setting-up-bigquery#setting-up) and [Loading data (BigQuery)](https://docs.getdbt.com/docs/get-started/getting-started/getting-set-up/setting-up-bigquery#loading-data)
3. Create a service account on GCP, granted the role of 'BigQuery Admin' and download the service account key. Move the service account key to `~/.dbt/` folder.
4. Create a [Github account](https://github.com/join).

Steps:
1. Initiate the `jaffle_shop` project using the `init` command. It will create an interative session for you to set the configuration and additional infomation.
    ``` shell
    dbt init jaffle_shop
    ```
    ![](https://i.imgur.com/dATqXFN.png)
    
    This will create a file structure as follows.
    ``` shell
    jaffle_shop/
    ├── README.md
    ├── analyses
    ├── dbt_project.yml
    ├── macros
    ├── models
    │   └── example
    │       ├── my_first_dbt_model.sql
    │       ├── my_second_dbt_model.sql
    │       └── schema.yml
    ├── seeds
    ├── snapshots
    └── tests
    ```
    It will also create a profile file `~/.dbt/profiles.yml`
    ![](https://i.imgur.com/n3Z9tRM.png)
2. Navigate into your project directory
    ``` shell
    cd jaffle_shop
    ```
3. Run `dbt debug` to ensure that the setup is working as expected.
    ![](https://i.imgur.com/EpaJdpm.png)
4. Run `dbt run` to build example models
    ![](https://i.imgur.com/nVUFxft.png)
