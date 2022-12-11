# MLflow
Refer to [documentation](https://mlflow.org/docs/latest/index.html).

*This guide only focus on MLFlow Python APIs and CLI.*

MLflow is an open source platform for managing the end-to-end machine learning lifecycle. It tackles four **primary functions**.
| Function  | Description  |
|---|---|
| **MLFlow Tracking** | Tracking experiments parameters, code versions, metrics and artifacts |
| **MLFlow Project** | Packaging ML code in a reusable, reproducible form |
| **MLFlow Models** | Managing and deploying models |
| **MLFlow Model Registry** | Providing a central model store to collaboratively manage the full lifecycle of an MLFlow model |

![](https://i.imgur.com/T2dw9Cr.png)

Core philosophy:
- As few constaints as possible on workflow (can run in `.ipynb` and `.py`)
- Design to work with any ML library
- Follow convention and require minimal change to existing codebase
- Reproducible and reusable by multiple data scientists


# Table of Contents
- [MLflow](#mlflow)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
- [MLFlow Tracking](#mlflow-tracking)
  - [Concepts](#concepts)
  - [Commands](#commands)
    - [Setting Up](#setting-up)
    - [Logging](#logging)
    - [Miscellaneous](#miscellaneous)
  - [Environment Variables](#environment-variables)
  - [Tracking Server](#tracking-server)
    - [Storage](#storage)
      - [Backend Stores](#backend-stores)
      - [Artifact Stores](#artifact-stores)
- [MLFlow Projects](#mlflow-projects)
- [MLFlow Models](#mlflow-models)
- [MLFlow Registry](#mlflow-registry)
  - [Concepts](#concepts-1)
  - [Miscellaneous](#miscellaneous-1)

# Installation
``` python
# Install MLflow
pip install mlflow

# Install MLflow with extra ML libraries and 3rd-party tools
pip install mlflow[extras]

# Install a lightweight version of MLflow
pip install mlflow-skinny
```

# MLFlow Tracking
The MLflow Tracking component is an API and UI for logging parameters, code versions, metrics, and output files when running your machine learning code and for later visualizing the results.

## Concepts
- `run` - Executions of data science code
  Contains of 
  - `code version` - git commit hash for the run
  - `start & end date`
  - `source` - Name of the run file, or the project name and entry point
  - `parameters` - key-value pair
  - `metrics` - key-value pair
  - `artifacts` - output files in any format (eg: image, models, data)
- `experiment` - A group of `runs` for a specific tasks
  - When an experiment is created, the artifact storage location from the configuration of the tracking server is logged in the experiment’s metadata.
- `project`
  Contains of
  - project URI
  - source version
- `local files`, `SQLAlchemy compatible database`, `tracking server` - location where runs are recorded
- `local files`, `remote file storage solutions` - location where MLFlow artifacts are persisted
- `storage`
  - `backend store` - persists MLflow entities (runs, parameters, metrics, tags, notes, metadata, etc)
    - Implementation of abstract class `AbstractStore`
    - `FileStore`
    - `SQLAlchemyStore`
    - `RestStore` - communicate with `Tracking Server` by sending REST API requests
  - `artifact store` - persists artifacts (files, models, images, in-memory objects, or model summary, etc)
    - Implementation of abstract class `ArtifactRepository`
    - `LocalArtifactRepository`
    - `S3ArtifactRepository`
    - `HttpArtifactRepository`
  - Example:
    1. **Localhost** 
      - `backend store`: `FileStore`
      - `artifact store`: `LocalArtifactRepository`
    2. **Localhost + SQLite** 
      - `backend store`: `SQLAlchemyStore` (in database file: `mlruns.db`)
      - `artifact store`: `LocalArtifactRepository` (in local `./mlruns` directory)
    3. **Localhost + Tracking Server in Localhost**
        ``` shell
        mlflow server --backend-store-uri file:///path/to/mlruns --no-serve-artifacts
        ```
        The URI of `backend store` and `artifact store` are configured in `Tracking Server`.
        - `backend store`: `RestStore` &rarr; `FileStore` connected from `Tracking Server`
        - `artifact store`: `RestStore` &rarr; (fetch `artifact store` URI from `Tracking Server`) &rarr; `LocalArtifactRepository` 
    4. **Remote Tracking Server and Stores**
        ``` shell
        mlflow server --backend-store-uri postgresql://user:password@postgres:5432/mlflowdb --default-artifact-root s3://bucket_name --host remote_host --no-serve-artifacts
        ```
        The URI of `backend store` and `artifact store` are configured in `Tracking Server`.
        - `backend store`: `RestStore` &rarr; remote `SQLAlchemyStore ` (PostgreSQL) connected from `Tracking Server`
        - `artifact store`: `RestStore` &rarr; (fetch `artifact store` URI from `Tracking Server`) &rarr; `S3ArtifactRepository` (connected using boto3 client) 
    5. **Remote Tracking Server with proxied artifact storage access**
        ``` shell
        mlflow server \
        --backend-store-uri postgresql://user:password@postgres:5432/mlflowdb \
        # Artifact access is enabled through the proxy URI 'mlflow-artifacts:/',
        # giving users access to this location without having to manage credentials
        # or permissions.
        --artifact-destination-root s3://bucket_name \
        --host remote_host
        ```
        Same object store configuration with `4.`. Tracking server acts as a proxy server for artifact related operations. (**eliminate needs for end user to have credential to object store**)
        - `backend store`: `RestStore` &rarr; remote `SQLAlchemyStore ` (PostgreSQL) connected from `Tracking Server`
        - `artifact store`: `HttpArtifactRepository` &rarr; `FileStore` (S3 Bucket) connected from `Tracking Server`
    6. **Remote Tracking Server only for Artifact**
        Possible scenario: Splitting `backend store` and `artifact store` to different Tracking Servers
        ``` shell
        mlflow server --artifact-destination-root s3://bucket_name --artifacts-only --host remote_host
        ```
- Tracking UI - Visualize, search and compare runs, as well as download run artifacts or metadata for analysis in other tools.
- `flavors`
- `tag`
## Commands
### Setting Up
Things to set up:
- Tracking URI
  - `mlflow.set_tracking_uri()` (or set environment variable `MLFLOW_TRACKING_URI `) - Connect to a tracking URI
  - `mlflow.get_tracking_uri()`  - Return current tracking URI
- Experiment 
  - Using command line 
    ```python
    mlflow experiments create --experiment-name fraud-detection
    ```
    ```python
    mlflow experiments create --experiment-id 42
    ```
  - `mlflow.create_experiment()` - Create a new experiment and returns its ID  
  - `mlflow.set_experiment()` - Set an experiment as active. If experiment doesn't exist, create a new one
- Run (Can be `mlflow.ActiveRun` object returned by `mlflow.start_run` which is a context manager (mean can used with `with`), or `mlflow.entities.Run` object which cannot access run attributes)
  - `mlflow.start_run(run_id=..., run_name=..., experiment_id=...)` - Return currently active run (if any), or starts a `mlflow.ActiveRun` as context manager for current run. (you can don't explicit run `start_run` as calling the logging functions with no active run will start a new one)
    ``` python
    with mlflow.start_run():
        mlflow.log_param("x", 1)
        mlflow.log_metric("y", 2)
      ...
    ```
  - `mlflow.end_run()` - Ends the currently active run
  - `mlflow.active_run()` - Returns currently active run, if any. 
  - `mlflow.last_active_run()` - Returns currently active run, if any. Else, return last terminated run.

To get active run attributes (parameters, metrics, etc)
``` python
client = mlflow.MlflowClient()
data = client.get_run(mlflow.active_run().info.run_id).data
```

### Logging
x-axis can be `timestamp` or `step` (not much constraint on order and sign besides of it should be integer)
- `mlflow.log_param()`  
- `mlflow.log_params()`  
- `mlflow.log_metric()`  
``` python
with mlflow.start_run():
    for epoch in range(0, 3):
        mlflow.log_metric(key="quality", value=2*epoch, step=epoch)
```
- `mlflow.log_metrics()`  
- `mlflow.set_tag()`  
- `mlflow.set_tags()`  
- `mlflow.log_artifact()`  
- `mlflow.log_artifacts()` - Logs all the files in a given directory as artifacts
- `mlflow.get_artifact_uri()`  
- `mlflow.autolog()` - Automatic log metrics, parameters and models without the need for explicit log statements. Can be use for supported libraries. Should be called before the training code.
- Library-specific autolog
  - Scikit-learn - `mlflow.sklearn.autolog()`
  - Keras - `mlflow.tensorflow.autolog() `
  - Gluon - `mlflow.gluon.autolog()`
  - XGBoost - `mlflow.xgboost.autolog()`
  - LightGBM - `mlflow.lightgbm.autolog()`
  - Statsmodels - `mlflow.statsmodels.autolog()`
  - Spark - `mlflow.spark.autolog()`
  - Fastai - ` mlflow.fastai.autolog()`
  - Pytorch - `mlflow.pytorch.autolog()`

### Miscellaneous
- `MlflowClient` - tracking service API
``` python
from  mlflow.tracking import MlflowClient
client = MlflowClient()
```
- `mlflow ui` - view tracking UI


## Environment Variables
- MLFLOW_EXPERIMENT_NAME
  ``` python
  export MLFLOW_EXPERIMENT_NAME=fraud-detection
  ```
- MLFLOW_EXPERIMENT_ID 

## Tracking Server
`mlflow server`

Example:
``` shell
mlflow server \
    --backend-store-uri /mnt/persistent-disk \
    --default-artifact-root s3://my-mlflow-bucket/ \
    --host 0.0.0.0
```
### Storage
#### Backend Stores
`--backend-store-uri`
- Default location: local `./mlruns` directory
- Type of remote tracking URIs
  - Local file path (eg: `file:/my/local/dir`)
  - Database *(support mysql, mssql, sqlite, postgresql)* (encoded as `<dialect>+<driver>://<username>:<password>@<host>:<port>/<database>`)
  - HTTP Server (specified as `https://my-server:5000`)
  - Databricks (specified as `databricks://<profileName>`)

#### Artifact Stores
`--default-artifact-root`  

Should be location suitable for large data.  

Object store location: `{URI}/mlartifacts`  

- `artifact_location` - property of `mlflow.entities.Experiment`  
- `artifact_uri` - property on `mlflow.entities.RunInfo`  

Example:
- Amazon S3 and S3-compatible storage
- Azure Blob Storage
- Google Cloud Storage
- FTP server
- SFTP Server
- NFS
- HDFS

`--serve-artifacts` - default behaviour, enable proxies access for artifacts  
`--no-serve-artifacts` - disable proxies access for artifacts  
`--artifact-only` - only for storing artifacts

If the host or host:port declaration is absent in client artifact requests to the MLflow server, the client API will assume that the host is the same as the MLflow Tracking uri.

# MLFlow Projects


# MLFlow Models


# MLFlow Registry

## Concepts
- Model Lineage


## Miscellaneous
MLflow will automatically try to use LibYAML bindings if they are already installed.
``` shell
# On Ubuntu/Debian
apt-get install libyaml-cpp-dev libyaml-dev

# On macOS using Homebrew
brew install yaml-cpp libyaml
```