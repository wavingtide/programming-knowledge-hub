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
    - [Logging Commands](#logging-commands)
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
  log_param('learning_rate', 0.01)
  ```
- `log_params`
  ``` python
  params = {'learning_rate': 0.01, 'n_estimators': 10}
  log_params(params)
  ```
- `log_metric`
  ``` python
  log_metric('mse', 2500.00)
  ```
  `log_metric` can accept `step` (default to `0`)
  ``` python
  for step in range(0, 100):
      log_metric('mse', 100*step, step)
  ```
- `log_metrics` (can also accept single integer `step`)
  ``` python
  metrics = {'mse': 2500.00, 'rmse': 50.00}
  log_metrics(metrics)
  ```
- `log_artifact` - log one file or one directory
  ``` python
  with open("features.txt", 'w') as f:
      f.write('room, price, zipcode')

  log_artifact('feature.txt')
  ```
  One can specify the `artifact_path`, which is the directory in `artifact_uri` to write to.
  ``` python
  log_artifact('feature.txt', artifact_path='feat')
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

  log_artifacts('data')
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

### Runs
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
for lr in (0.01, 0.02, 0.03):
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

### Experiments
You can organize runs into experiments for a specific task.

The experiment of a run is decided in the following order
- `experiment_id` if it is specified in `mlflow.start_run()`
- Activated experiment using `mlflow.set_experiment()`
- Environment variable `MLFLOW_EXPERIMENT_NAME`
- Environment variable `MLFLOW_EXPERIMENT_ID`
- Default experiment defined by the tracking server

You can activate an experiment using `mlflow.set_experiment()`, it accepts exactly one of (`experiment_name`, `experiment_id`)
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

### Logging
x-axis can be `timestamp` or `step` (not much constraint on order and sign besides of it should be integer) 
- `mlflow.set_tag()`  
- `mlflow.set_tags()`  
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