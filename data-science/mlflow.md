# MLflow
Refer to [documentation](https://mlflow.org/docs/latest/index.html).

*This guide focus mainly on MLflow Python and CLI. For REST APIs, R and Java APIs, please refer to the documentation.*

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
    - [Logging Commands](#logging-commands)
    - [Automatic Logging](#automatic-logging)
  - [Runs](#runs)
  - [Experiments](#experiments)
    - [Command line](#command-line)
  - [Tags](#tags)
  - [Storage](#storage)
    - [Backend Store](#backend-store)
    - [Artifact Store](#artifact-store)
    - [Code Implementation of Backend and Artifact Store](#code-implementation-of-backend-and-artifact-store)
  - [Tracking Server](#tracking-server)
    - [Set up a tracking server](#set-up-a-tracking-server)
    - [Connecting to a Tracking Server](#connecting-to-a-tracking-server)
    - [`mlflow server` Command Options](#mlflow-server-command-options)
      - [Enabling Proxied Artifact Storage Access](#enabling-proxied-artifact-storage-access)
    - [Tracking Server Authentication](#tracking-server-authentication)
    - [Tracking Server Example](#tracking-server-example)
  - [MlflowClient](#mlflowclient)
  - [Tracking UI](#tracking-ui)
  - [Search](#search)
  - [Delete](#delete)
- [MLflow Projects](#mlflow-projects)
  - [Concepts](#concepts-1)
  - [`MLproject` file](#mlproject-file)
- [MLflow Models](#mlflow-models)
- [MLflow Registry](#mlflow-registry)
  - [UI Workflow](#ui-workflow)
  - [API Workflow](#api-workflow)
  - [Concepts](#concepts-2)
  - [Miscellaneous](#miscellaneous)
    - [File Store Performance](#file-store-performance)

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
*(Python API)*
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
log_metric('foo', 4)  # all value are logged

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

### Logging Commands
- `log_param`
  ``` python
  mlflow.log_param('learning_rate', 0.01)
  ```
- `log_params`
  ``` python
  params = {'learning_rate': 0.01, 'n_estimators': 10}
  mlflow.log_params(params)
  ```
- `log_metric`
  ``` python
  mlflow.log_metric('mse', 2500.00)
  ```
  `log_metric` can accept `step` (default to `0`). Step must be valid 64-bit integer value, can be negative, have gap and out of order in successive calls. For example, (10, -4, 23, 5).
  ``` python
  for step in range(0, 100):
      mlflow.log_metric('mse', 100*step, step)
  ```
  The visualization of the change of metrics is available in the tracking UI. The x-axis can be `step` or `timestamp`.
  ![](https://i.imgur.com/UaeDILo.png)
  ![](https://i.imgur.com/qI3SZpO.png)
- `log_metrics` (can also accept single integer `step`)
  ``` python
  metrics = {'mse': 2500.00, 'rmse': 50.00}
  mlflow.log_metrics(metrics)
  ```
- `log_artifact` - log one file or one directory
  ``` python
  with open("features.txt", 'w') as f:
      f.write('room, price, zipcode')

  mlflow.log_artifact('feature.txt')
  ```
  One can specify the `artifact_path`, which is the directory in `artifact_uri` to write to.
  ``` python
  mlflow.log_artifact('feature.txt', artifact_path='feat')
  ```
- `log_artifacts` - log all contents of a directory
  ``` python
  import json
  import os

  os.makedirs("data", exist_ok=True)
  with open("data/data.json", 'w', encoding='utf-8') as f:
      json.dump({'name': 'teresa', 'type': 'owner'}, f, indent=2)
  with open("data/features.txt", 'w') as f:
      f.write('room, price, zipcode')

  mlflow.log_artifacts('data')
  ```
  One can also specify the `artifact_path`.

Notice that while using `log_artifact` and `log_artifacts`, you need to save the artifact object to a file. MLflow has functions to directly save several types of artifacts. The following functions accept a python object and a `artifact_file` indicating the file in `artifact_uri` to write to. You should indicate the appropriate file extension.

| Functions | Accepted Python Object | `artifact_file` remark |
| --- | --- | --- |
| `log_dict` | JSON/YAML-serializable object (eg: dict) | The file extension should be any of ["`.json`", "`.yml`", "`.yaml`"], else JSON format will be used |
| `log_figure` | [`matplotlib.figure.Figure`](https://matplotlib.org/stable/api/figure_api.html#matplotlib.figure.Figure) <br> [`plotly.graph_objects.Figure`](https://plotly.com/python-api-reference/generated/plotly.graph_objects.Figure.html) | - |
| `log_image` | [`numpy.ndarray`](https://numpy.org/doc/stable/reference/generated/numpy.ndarray.html) <br> [`PIL.Image.Image`](https://pillow.readthedocs.io/en/stable/reference/Image.html#PIL.Image.Image) | Numpy array support bool, integer (0~255), float (0.0~1.0). <br> Out-of-range integer and float values will be clipped to [0, 255] and [0, 1]. <br> Grayscale (H x W / H x W x 1), RGB channel (H x W x 3) and RGBA channel (H x W x 4) order are supported. |
| `log_text` | text | - |

Dictionary example
``` python
dictionary = {"k": "v"}

mlflow.log_dict(dictionary, "data.yml") # save in yaml format
mlflow.log_dict(dictionary, "data.txt") # save in json format
```

Matplotlib example
``` python
import matplotlib.pyplot as plt

fig, ax = plt.subplots()
ax.plot([0, 1], [2, 3])

mlflow.log_figure(fig, "figure.png")
```
Plotly example
``` python
from plotly import graph_objects as go

fig = go.Figure(go.Scatter(x=[0, 1], y=[2, 3]))

mlflow.log_figure(fig, "figure.html")
```

Numpy example
``` python
import numpy as np

image = np.random.randint(0, 256, size=(100, 100, 3), dtype=np.uint8)

mlflow.log_image(image, "image.png")
```
Pillow example
``` python
from PIL import Image

image = Image.new("RGB", (100, 100))

mlflow.log_image(image, "image.png")
```

### Automatic Logging
MLflow provides automatic logging for many ML libraries. Automatic logging helps to log parameters, metrics and models based on convention, without the need for explicit log statements.

One can use `mlflow.autolog()` which enable autologging for each supported library, or use library-specific autolog calls. 

The supported libraries are
- Scikit-learn - `mlflow.sklearn.autolog()`
- Keras - `mlflow.tensorflow.autolog() `
- Gluon - `mlflow.gluon.autolog()`
- XGBoost - `mlflow.xgboost.autolog()`
- LightGBM - `mlflow.lightgbm.autolog()`
- Statsmodels - `mlflow.statsmodels.autolog()`
- Spark - `mlflow.spark.autolog()`
- Fastai - ` mlflow.fastai.autolog()`
- Pytorch - `mlflow.pytorch.autolog()`

Example of using scikit-learn `RandomForestRegressor`
``` python
import mlflow

from sklearn.model_selection import train_test_split
from sklearn.datasets import load_diabetes
from sklearn.ensemble import RandomForestRegressor

mlflow.autolog()

db = load_diabetes()
X_train, X_test, y_train, y_test = train_test_split(db.data, db.target)

# Create and train models.
rf = RandomForestRegressor(n_estimators = 100, max_depth = 6, max_features = 3)
rf.fit(X_train, y_train)

# Use the model to make predictions on the test dataset.
predictions = rf.predict(X_test)
autolog_run = mlflow.last_active_run()
```
When running the code, the log will inform you the creation of autologging.
``` shell
2023/01/02 23:21:12 INFO mlflow.utils.autologging_utils: Created MLflow autologging run with ID '7892b9756a6546fca721f36f1f270d76', which will track hyperparameters, performance metrics, model artifacts, and lineage information for the current sklearn workflow
```

The `mlruns` will look as follows. For flavors that automatically save models as an artifact, [MLflow Models](#mlflow-models) logs additional files for dependency management. 
``` shell
mlruns
├── 0
│   └── meta.yaml
├── 590323814279318902
│   ├── 7892b9756a6546fca721f36f1f270d76
│   │   ├── artifacts
│   │   │   ├── estimator.html
│   │   │   └── model
│   │   │       ├── MLmodel
│   │   │       ├── conda.yaml
│   │   │       ├── model.pkl
│   │   │       ├── python_env.yaml
│   │   │       └── requirements.txt
│   │   ├── meta.yaml
│   │   ├── metrics
│   │   │   ├── training_mean_absolute_error
│   │   │   ├── training_mean_squared_error
│   │   │   ├── training_r2_score
│   │   │   ├── training_root_mean_squared_error
│   │   │   └── training_score
│   │   ├── params
│   │   │   ├── bootstrap
│   │   │   ├── ccp_alpha
│   │   │   ├── criterion
│   │   │   ├── max_depth
│   │   │   ├── max_features
│   │   │   ├── max_leaf_nodes
│   │   │   ├── max_samples
│   │   │   ├── min_impurity_decrease
│   │   │   ├── min_samples_leaf
│   │   │   ├── min_samples_split
│   │   │   ├── min_weight_fraction_leaf
│   │   │   ├── n_estimators
│   │   │   ├── n_jobs
│   │   │   ├── oob_score
│   │   │   ├── random_state
│   │   │   ├── verbose
│   │   │   └── warm_start
│   │   └── tags
│   │       ├── estimator_class
│   │       ├── estimator_name
│   │       ├── mlflow.autologging
│   │       ├── mlflow.log-model.history
│   │       ├── mlflow.runName
│   │       ├── mlflow.source.name
│   │       ├── mlflow.source.type
│   │       └── mlflow.user
│   └── meta.yaml
└── models
```

For more details about the autologging of each supported libraries, please refer to [mlflow documentation](https://mlflow.org/docs/latest/tracking.html#automatic-logging).

## Runs
Calling one of the logging function with no active run automatically starts a new run. 

To allow better control of the run, use `mlflow.start_run()` and `mlflow.end_run()` to indicate the start and end of a MLflow run.

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

You can launch multiple runs in one program by calling `with mlflow.start_run()` multiple time.
``` python
for lr in (0.01, 0.1, 0.5):
    with mlflow.start_run():
        mlflow.log_param("learning_rate", lr)
```

To resume an existing run, you can pass a `run_id` to `mlflow.start_run()` or set an environment variable `MLFLOW_RUN_ID`. (`run_id` takes precedence over `MLFLOW_RUN_ID`)
``` python
# initial run
with mlflow.start_run() as run:
    mlflow.log_param("param1", 1)

# resuming the initial run
with mlflow.start_run(run_id=run.info.run_id):
    mlflow.log_param("param2", 2)
```

If you are running a new run, you can set the `experiment_id` and `run_name` in `mlflow.start_run()`.
``` python
with mlflow.start_run(experiment_id=0,
                      run_name="potatobanana"):
    mlflow.log_param("param1", 1)
```

To provide more metadata for a run, you can state if the run is nested, and the tags and description.
``` python
with mlflow.start_run(nested=False, tags={"author": "wavet"}, description="An example start run"):
    mlflow.log_param("param1", 1)
```

You can also use `mlflow.active_run()` and `mlflow.last_active_run()` to get the active or last active run object.

``` python
import mlflow

with mlflow.start_run():
    run = mlflow.active_run()
    print("Active run_id: {}".format(run.info.run_id))
```

There are 2 types of run objects defined in MLflow
- `mlflow.entities.Run` (`mlflow.entities.run.Run`)
- `mlflow.ActiveRun` (`mlflow.tracking.fluent.ActiveRun`)

`mlflow.ActiveRun` object returned by `mlflow.start_run()` or `mlflow.active_run()` does not store the currently-active run attributes (parameter, metrics). To access the run attributes during the run, use `MlflowClient` as follows

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

## Experiments
MLflow can organize runs into **experiments**, which can be useful for comparing runs intended to tackle a specific task.

The experiment of a run is decided in the following order
- `experiment_id` if it is specified in `mlflow.start_run()`
- Activated experiment using `mlflow.set_experiment()`
- Environment variable `MLFLOW_EXPERIMENT_NAME`
- Environment variable `MLFLOW_EXPERIMENT_ID`
- Default experiment defined by the tracking server

You can activate an experiment using `mlflow.set_experiment()`, it accepts exactly one of (`experiment_name`, `experiment_id`).
``` python
mlflow.set_experiment("new_experiment")

with mlflow.start_run():
    mlflow.log_param("params1", 1)
```
``` python
mlflow.set_experiment(experiment_id='0')

with mlflow.start_run():
    mlflow.log_param("params1", 1)
```

To allow more configurations on the experiment, you can use `mlflow.create_experiment()`. Besides of experiment name, you can specify the `artifact_location` and experiment `tags`.
``` python
experiment_id = mlflow.create_experiment(
    "Social NLP Experiments",
    artifact_location=Path.cwd().joinpath("mlruns").as_uri(),
    tags={"version": "v1", "priority": "P1"},
)

mlflow.set_experiment(experiment_id=experiment_id)
```

Use `mlflow.get_experiment()` to get the experiment object by experiment id.
``` python
experiment = mlflow.get_experiment("0")
```

### Command line
Use MLflow CLI to create an experiment
``` shell
# setting environment variable
export MLFLOW_EXPERIMENT_NAME=fraud-detection
```

``` shell
# creating the experiments
mlflow experiments create --experiment-name fraud-detection
```

You can pass `--experiment-name [name]` or `--experiment-id [id]` to an individual run in CLI.
``` shell
mlflow run ... --experiment-name [name]
```

## Tags
Tags are extra information that are not parameters, metrics and artifacts. Some examples include data version, model version, author. MLflow allows logging tags at run and experiment level. 
- Use  `mlflow.set_tag()` and `mlflow.set_tags()` to set tags for a run. 
- Use `mlflow.set_experiment_tag()` and `mlflow.set_experiment_tags()`to set tags for an experiment.

``` python
with mlflow.start_run():
    mlflow.set_tag("code.version": "2.2.0")

    mlflow.set_tags({
        "team": "engineering",
        "dataset": "rose1"
    })
```
``` python
with mlflow.start_run():
    mlflow.set_experiment_tag("release.version": "2.2.0")

    mlflow.set_experiment_tags({
        "company": "foobar limited",
        "dataset_type": "flower"
    })
```
Some commands (such as `create_experiment`, `start_run`, `register_model`) also accept parameter `tags` and a dictionary.

Tag keys that start with `mlflow` are reserved for internal use. Please refer to [mlflow system tag documentation](https://mlflow.org/docs/latest/tracking.html#system-tags) to see the full list of system tags.

## Storage
MLflow uses two components for storage, backend store and artifact store.
- backend store - persists MLflow entities (runs and experiment metadata, parameters, metrics, tags, notes, etc)
- artifact store - persists artifacts (files, models, images, in-memory objects, or model summary, etc), suitable for large data

Both backend store and artifact store are defaults as `./mlrun`.

### Backend Store
MLflow supports 2 types of backend store: *file store* and *database-backend store*
- File store backend `./path_to_store` or `file:/path_to_store`
- Database-backend store *(support SQLAlchemy compatible database - mysql, mssql, sqlite, postgresql)* `<dialect>+<driver>://<username>:<password>@<host>:<port>/<database>`. Drivers are optional.

Backend store can be set using `mlflow server` in CLI, or it will follow the behaviour based on the tracking server URI set by `mlflow.set_tracking_uri`.

### Artifact Store
MLflow supports the following storage systems as artifact stores 
- Local file paths
- Amazon S3 and S3-compatible storage (`s3://<bucket>/<path>`)
- Azure Blob Storage (`wasbs://<container>@<storage-account>.blob.core.windows.net/<path>`)
- Google Cloud Storage (`gs://<bucket>/<path>`)
- FTP server (`ftp://user@host/path/to/directory `)
- SFTP Server (`sftp://user@host/path/to/directory`)
- NFS (`/mnt/nfs`)
- HDFS (`hdfs://<host>:<port>/<path>`, `hdfs://<path>`)

Artifact store can be set in `artifact_location` in `mlflow.create_experiment()` or `mlflow server` using CLI.

To allow the server and clients to access the artifact location, the cloud provider credentials should be configured as usual. For example, set up `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variable when using Amazon S3.

The MLflow client caches artifact location information on a per-run basis. Root artifact URI are stored as 
- `artifact_location` property of `mlflow.entities.Experiment`
- `artifact_uri` property of `mlflow.entities.RunInfo`

For more information regarding each supported storage systems, check out [mlflow documentation](https://mlflow.org/docs/latest/tracking.html#amazon-s3-and-s3-compatible-storage).

### Code Implementation of Backend and Artifact Store
Backend store (concrete implementation of abstract class `AbstractStore`)
- `FileStore`
- `SQLAlchemyStore`
- `RestStore`

Artifact Store (concrete implementations of the abstract class `ArtifactRepository`)
- `LocalArtifactRepository`
- `S3ArtifactRepository`
- `HttpArtifactRepository`

## Tracking Server
### Set up a tracking server
Tracking server is the server that is running the MLflow Tracking component. You can set up the backend store, artifact store for a mlflow server. It is default to `./mlruns`.

The tracking server URI can be
- Local file path `file:/my/local/dir`
- Database *(support SQLAlchemy compatible database - mysql, mssql, sqlite, postgresql)* `<dialect>+<driver>://<username>:<password>@<host>:<port>/<database>`
- HTTP server `https://my-server:5000` (example: running on a VM)
- Databricks workspace `databricks://<profileName>`

When using a tracking server, MLflow client acts as a client connecting to the tracking server.

To run an MLflow tracking server, you need to use CLI `mlflow server`. It is a CLI command because you might want to set up a server remotely, by running `mlflow server` in a remote machine.

The server listens on http://localhost:5000 by default and only accepts connections from the local machine. To let the server accept connections from other machines, pass `--host 0.0.0.0` to listen on all network interfaces.

Example:
``` shell
mlflow server \
    --backend-store-uri /mnt/persistent-disk \
    --default-artifact-root s3://my-mlflow-bucket/ \
    --host 0.0.0.0
```

### Connecting to a Tracking Server
After a tracking server is set up, you can set the tracking server using `mlflow.set_tracking_uri()` or set the environment variable `MLFLOW_TRACKING_URI` to connect to the tracking server.

Local file
``` python
mlflow.set_tracking_uri("mlruns2")

with mlflow.start_run():
    mlflow.log_param("params1", 1)
```

Use `mlflow.get_tracking_uri()` and `mlflow.get_artifact_uri()` to get the tracking URI and artifact URI of the run respectively.

### `mlflow server` Command Options
`mlflow server` accepts the following command options.
- `--backend-store-uri <URI>` (default: `.mlruns` directory)
- `--registry-store-uri <URI>` (default: `backend-store-uri`)
- `--default-artifact-root <URI>`
- `--serve-artifacts` (default), `--no-serve-artifacts`
- `--artifacts-only` (default: False)
- `--artifacts-destination <URI>` (default: local `./mlartifacts` directory)
- `-h`, `--host <HOST>` (default: 127.0.0.1)
- `-p`, `--port <port>` (default: 5000)
- `-w`, `--workers <workers>` (default: 4)
- `--static-prefix <static_prefix>`
- `--gunicorn-opts <gunicorn_opts>`
- `--waitress-opts <waitress_opts>`
- `--expose-prometheus <expose_prometheus>`

These command options are correspond to the following environment variables.
- `MLFLOW_BACKEND_STORE_URI`
- `MLFLOW_REGISTRY_STORE_URI`
- `MLFLOW_DEFAULT_ARTIFACT_ROOT`
- `MLFLOW_SERVE_ARTIFACTS`
- `MLFLOW_ARTIFACTS_ONLY`
- `MLFLOW_ARTIFACTS_DESTINATION`
- `MLFLOW_HOST`
- `MLFLOW_PORT`
- `MLFLOW_WORKERS`
- `MLFLOW_STATIC_PREFIX`
- `MLFLOW_GUNICORN_OPTS`
- `MLFLOW_EXPOSE_PROMETHEUS`

`--backend_store-uri`, `--registry-store-uri`, `--default-artifact-root` allows the setting of URI of backend store, [MLflow model registry](#mlflow-registry) and artifact store. To use MLflow model registry, `--registry-store-uri` must be a database-backend store.

`--serve-artifacts`, `--no-serve-artifacts`, `--artifacts-only` are flag for different configurations of the tracking server. 

| `--serve-artifacts` | `--no-serve-artifacts` | `--artifacts-only` |
| --- | --- | --- |
| Enable proxied access for artifacts | Disable proxied access for artifacts | Configures the mlflow server to be used only for proxied artifact serving |
| ![](https://i.imgur.com/rhXDROV.png) | ![](https://i.imgur.com/jv5dq5D.png) | ![](https://i.imgur.com/wQVBISo.png) |

#### Enabling Proxied Artifact Storage Access
When using `--serve-artifacts` and `--artifacts-only` flag, the MLflow server is configured as an artifacts HTTP proxy server. Once the tracking server is configured with the appropriate access requirements and started, the users can pass artifact requests through the tracking server to store and retrieve artifacts **without having to interact with the underlying object store servies**, which eliminates the need of user authentication to the remote object store.

Only when the artifact root location is set to `http` or `mlflow-artifacts` URI, `--artifacts-destination` can be set to configure the base location to resolve artifact related requests. It is default as `./mlartifacts` directory.

The artifact store URI (eg: `s3:/my_bucket/mlartifacts`) will be replaced by `mlflow-artifacts:/`.

When started in `--artifacts-only` mode, the tracking server will not permit any operations other than saving, loading and listing artifacts. 

Provided an MLflow server configuration where the `--default-artifact-root` is `s3://my-root-bucket`. The following patterns will all resolve to the configured proxied object store location of `s3://my-root-bucket/mlartifacts`
- `https://<host>:<port>/mlartifacts`
- `http://<host>/mlartifacts`
- `mlflow-artifacts://<host>/mlartifacts`
- `mlflow-artifacts://<host>:<port>/mlartifacts`
- `mlflow-artifacts:/mlartifacts`

If the `host` or `host:port` declaration is absent in client artifact requests to the MLflow server, the client API will assume that the host is the same as the MLflow Tracking uri.

When using `--artifacts-only`, the client should interact with this server explicitly by including a `host` or `host:port` definition for URI location references for artifacts. Otherwise, all artifacts requests will route to the MLflow tracking server, which defeat the purpose of running a distinct artifact store.

Access credential and configuration for the artifact storage location are configured once during server initialization in the place of having user handle access credentials for artifact-based operation. All users that have access to the Tracking Server will have access to artifacts.

### Tracking Server Authentication
To allow passing HTTP authentication to the tracking server, MLflow uses the following environment variables.
- `MLFLOW_TRACKING_USERNAME`
- `MLFLOW_TRACKING_PASSWORD`
- `MLFLOW_TRACKING_TOKEN`
- `MLFLOW_TRACKING_INSECURE_TLS`
- `MLFLOW_TRACKING_SERVER_CERT_PATH` (cannot be set together with `MLFLOW_TRACKING_INSECURE_TLS`)
- `MLFLOW_TRACKING_CLIENT_CERT_PATH`

Both `MLFLOW_TRACKING_INSECURE_TLS` and `MLFLOW_TRACKING_SERVER_CERT_PATH` cannot be set at the same time.

### Tracking Server Example
``` shell
mlflow server --backend-store-uri file:///path/to/mlruns --no-serve-artifacts
```

``` shell
mlflow server --backend-store-uri postgresql://user:password@postgres:5432/mlflowdb --default-artifact-root s3://bucket_name --host remote_host --no-serve-artifacts
```

``` shell
mlflow server \
  --backend-store-uri postgresql://user:password@postgres:5432/mlflowdb \
  # Artifact access is enabled through the proxy URI 'mlflow-artifacts:/',
  # giving users access to this location without having to manage credentials
  # or permissions.
  --artifacts-destination s3://bucket_name \
  --host remote_host
```

``` shell
mlflow server --artifacts-destination s3://bucket_name --artifacts-only --host remote_host
```

## MlflowClient
MLflow provides a more detailed Tracking Service API for managing experiments and runs directly.

``` python
from  mlflow.tracking import MlflowClient
client = MlflowClient()
experiments = client.search_experiments() # returns a list of mlflow.entities.Experiment
run = client.create_run(experiments[0].experiment_id) # returns mlflow.entities.Run
client.log_param(run.info.run_id, "hello", "world")
client.set_terminated(run.info.run_id)
client.set_tag(run.info.run_id, "tag_key", "tag_value")
```

## Tracking UI
Tracking UI provides the following key features
- Experiment-based run listing and comparison (including run comparison across multiple experiments)
- Searching for runs by parameter or metric value
- Visualizing run metrics
- Downloading run results


## Search

## Delete

# MLflow Projects
An MLflow project is a format for packaging data science code in a reusable and reproducible way, based primarily on convention. It includes an API and command-line tools for running projects.

## Concepts
- `entry point` - `.py` or `.sh` file that can be run within the project
- `environment` - conda environments, virtualenv environments and Docker containers that should be used to execute project entry points

## `MLproject` file
Example
``` yaml
name: My Project

python_env: python_env.yaml
# or
# conda_env: my_env.yaml
# or
# docker_env:
#    image:  mlflow-docker-example

entry_points:
  main:
    parameters:
      data_file: path
      regularization: {type: float, default: 0.1}
    command: "python train.py -r {regularization} {data_file}"
  validate:
    parameters:
      data_file: path
    command: "python validate.py {data_file}"
```



# MLflow Models
An MLflow model is a standard format/convention for **packaging machine learning models** that can be **used in a variety of downstream tools** (different "flavors" that can be understood by different downstream tools).

`MLmodel` file
Example
``` yaml
323814279318902/7892b9756a6546fca721f36f1f270d76/artifacts/model/MLmodel 
artifact_path: model
flavors:
  python_function:
    env:
      conda: conda.yaml
      virtualenv: python_env.yaml
    loader_module: mlflow.sklearn
    model_path: model.pkl
    predict_fn: predict
    python_version: 3.8.10
  sklearn:
    code: null
    pickled_model: model.pkl
    serialization_format: cloudpickle
    sklearn_version: 1.2.0
mlflow_version: 2.1.1
model_uuid: 7d275a137a2e4f479587d962372f0e8b
run_id: 7892b9756a6546fca721f36f1f270d76
signature:
  inputs: '[{"type": "tensor", "tensor-spec": {"dtype": "float64", "shape": [-1, 10]}}]'
  outputs: '[{"type": "tensor", "tensor-spec": {"dtype": "float64", "shape": [-1]}}]'
utc_time_created: '2023-01-02 15:21:13.202769'
```

# MLflow Registry
## UI Workflow

## API Workflow


## Concepts
- Model Lineage


## Miscellaneous
### File Store Performance
MLflow will automatically try to use LibYAML bindings if they are already installed. If there are performance issues with `file store` backend, it could mean LibYAML is not installed on your machine.
``` shell
# On Ubuntu/Debian
apt-get install libyaml-cpp-dev libyaml-dev

# On macOS using Homebrew
brew install yaml-cpp libyaml
```

After installing LibYAML, you need to reinstall PyYAML.
``` shell
# Reinstall PyYAML
pip --no-cache-dir install --force-reinstall -I pyyaml
```
