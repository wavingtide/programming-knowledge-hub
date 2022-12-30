# MLflow
Refer to [documentation](https://mlflow.org/docs/latest/index.html).

*This guide focus mainly on MLflow Python, REST APIs and CLI. For R and Java APIs, please refer to the documentation.*

MLflow is an open source platform for managing the end-to-end machine learning lifecycle. It tackles four **primary functions**.
| Function  | Description  |
|---|---|
| **MLflow Tracking** | Tracking experiments parameters, code versions, metrics and artifacts |
| **MLflow Project** | Packaging ML code in a reusable, reproducible form |
| **MLflow Models** | Managing and deploying models |
| **MLflow Model Registry** | Providing a central model store to collaboratively manage the full lifecycle of an MLflow model |

MLflow provides a tracking UI.
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
- [MLflow Tracking](#mlflow-tracking)
  - [Concepts](#concepts)
  - [Logging](#logging)
    - [Getting Started with Logging](#getting-started-with-logging)
    - [Runs](#runs)
    - [Experiments](#experiments)
    - [Automatic Logging](#automatic-logging)
    - [Search](#search)
  - [Storage and Tracking Server](#storage-and-tracking-server)
  - [Tracking UI](#tracking-ui)
  - [Commands](#commands)
    - [Setting Up](#setting-up)
    - [Logging](#logging-1)
    - [Miscellaneous](#miscellaneous)
  - [Environment Variables](#environment-variables)
  - [Tracking Server](#tracking-server)
    - [Storage](#storage)
      - [Backend Stores](#backend-stores)
      - [Artifact Stores](#artifact-stores)
- [MLflow Projects](#mlflow-projects)
- [MLflow Models](#mlflow-models)
- [MLflow Registry](#mlflow-registry)
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

# MLflow Tracking
The MLflow Tracking component is an API and UI for logging parameters, code versions, metrics, and output files when running your machine learning code and for later visualizing the results.

## Concepts
- `run` - Execution of code 
- `experiment` - A group of runs for a specific tasks
- `storage` 
  - `backend store` - persists MLflow entities (runs, parameters, metrics, tags, notes, metadata, etc)
  - `artifact store` - persists artifacts (files, models, images, in-memory objects, or model summary, etc)
- `tracking UI` - Visualize, search and compare runs, as well as download run artifacts or metadata for analysis in other tools

## Logging
### Getting Started with Logging
You can use `log_param`, `log_metric`, `log_artifact` to log the run info.

Add the following code to `main.py` file and run.
``` python
import os
from mlflow import log_metric, log_param, log_artifact

# log a parameter (key-value pair)
log_param("param1", 1)

# log a metric
log_metric('foo', 2)
log_metric('foo', 4)  # only the latest will be logged

# log an artifact
if not os.path.exists('outputs'):
    os.makedirs('outputs')
with open('outputs/test.txt', 'w') as f:
    f.write('hello world!')

log_artifact('outputs')
```

By default, the info is stored in `./mlruns` directory in the project directory, under experiment id `0` with experiment name `Default`. MLflow will create a random run id and name.

The `./mlruns` directory structure is as follows.
``` shell
mlruns/
└── 0
    ├── 73ed5776f5e04e23be739d46812cb6bd  # run id
    │   ├── artifacts
    │   │   └── outputs
    │   │       └── test.txt
    │   ├── meta.yaml  # metadata of the run 
    │   ├── metrics
    │   │   └── foo  # 1672364273330 2.0 0 1672364273332 4.0 0
    │   ├── params
    │   │   └── param1 # 1
    │   └── tags
    │       ├── mlflow.runName  # a random name
    │       ├── mlflow.source.name  # file that was run
    │       ├── mlflow.source.type  # LOCAL
    │       └── mlflow.user  # wavet
    └── meta.yaml  # metadata of the experiment
```

Most of the files are easy to understand. The `{experiment_id}/meta.yaml` file records metadata of the experiment (artifact, experiment, lifecycle, time).
``` shell
artifact_location: file:///home/wavet/Code/tutorial/playground-mlflow/mlruns/0
creation_time: 1672364273202
experiment_id: '0'
last_update_time: 1672364273202
lifecycle_stage: active
name: Default
```

The `{experiment_id}/{run_id}/meta.yaml` file records metadata of the run (artifact, entry point, time, run, source, status).
``` shell
artifact_uri: file:///home/wavet/Code/tutorial/playground-mlflow/mlruns/0/73ed5776f5e04e23be739d46812cb6bd/artifacts
end_time: 1672364273335
entry_point_name: ''
experiment_id: '0'
lifecycle_stage: active
run_id: 73ed5776f5e04e23be739d46812cb6bd
run_name: beautiful-dog-902
run_uuid: 73ed5776f5e04e23be739d46812cb6bd
source_name: ''
source_type: 4
source_version: ''
start_time: 1672364273319
status: 3
tags: []
user_id: wavet
```

Run `mlflow ui` in command line and visit `http://127.0.0.1:5000` to view the tracking UI.

![](https://i.imgur.com/j1vmMOh.png)  
![](https://imgur.com/C5tYkEv.png)

### Runs
Calling one of the logging function with no active run automatically starts a new run. 

To allow better control of the run, you can use `mlflow.start_run()` and `mlflow.end_run()` to indicate the start and end of a MLflow run.

``` python
import mlflow

mlflow.start_run()

# log a parameter (key-value pair)
mlflow.log_param("param1", 1)

mlflow.end_run()
```
`mlflow.start_run()` returns a `mlflow.ActiveRun` (`mlflow.tracking.fluent.ActiveRun`) object, which is a context manager and can be used with `with`.

``` python
import mlflow

with mlflow.start_run():
    mlflow.log_param("param1", 1)
```

With this, we can launch multiple runs in one program.

We can also use `mlflow.active_run()` and `mlflow.last_active_run()` to get the active or last active run object.

There are 2 types of run objects defined in MLflow
- `mlflow.entities.Run` (`mlflow.entities.run.Run`)
- `mlflow.ActiveRun` (`mlflow.tracking.fluent.ActiveRun`)

`mlflow.ActiveRun` object that is returned by `mlflow.start_run()` or `mlflow.active_run()` does not store the run attributes (parameter, metrics) during the run. To access the run attributes, use `MlflowClient` as follows

``` python
client = mlflow.MlflowClient()
data = client.get_run(mlflow.active_run().info.run_id).data
```
``` python
data

<RunData: metrics={'foo': 4.0}, params={'param1': '1'}, tags={'mlflow.runName': 'kindly-flea-597',
 'mlflow.source.name': '/home/wavet/Code/tutorial/playground-mlflow/src/main.py',
 'mlflow.source.type': 'LOCAL',
 'mlflow.user': 'wavet'}>
```

### Experiments
`mlflow.create_experiment()`  
`mlflow.set_experiment()`


### Automatic Logging

### Search 

## Storage and Tracking Server
Backend store and artifact store
- `backend store` - persists MLflow entities (runs, parameters, metrics, tags, notes, metadata, etc)
- `artifact store` - persists artifacts (files, models, images, in-memory objects, or model summary, etc)


The tracking server URI can be
- Local file path `file:/my/local/dir`
- Database `<dialect>+<driver>://<username>:<password>@<host>:<port>/<database>`
  - Support SQLAlchemy compatible database `mysql`, `mssql`, `sqlite`, `postgresql`
- HTTP server `https://my-server:5000`
- Databricks workspace `databricks://<profileName>`

`mlflow.set_tracking_uri()`
`mlflow.get_tracking_uri()`

Environment variable
`MLFLOW_TRACKING_URI`


## Tracking UI
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

# MLflow Projects
An MLflow project is a format for packaging data science code in a reusable and reproducible way, based primarily on convention. It includes an API and command-line tools for running projects.

`MLproject` file



# MLflow Models
An MLflow model is a standard format/convention for **packaging machine learning models** that can be **used in a variety of downstream tools** (different "flavors" that can be understood by different downstream tools).

`MLmodel` file

# MLflow Registry

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