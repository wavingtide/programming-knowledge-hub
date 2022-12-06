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
- As few constaints as possible
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
    - [Tracking Service API](#tracking-service-api)
- [MLFlow Projects](#mlflow-projects)
- [MLFlow Models](#mlflow-models)
- [MLFlow Registry](#mlflow-registry)

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
- `run` - executions of data science code
  - `code version` - git commit hash for the run
  - `start & end date`
  - `source` - Name of the run file, or the project name and entry point
  - `parameters` - key-value pair
  - `metrics` - key-value pair
  - `artifacts` - output files in any format (eg: image, models, data)
- `experiment` - a group of `runs` for a specific tasks
- `tracking server`
  - Default location: `mlruns` directory
  - Type of remote tracking URIs
    - Local file path (eg: `file:/my/local/dir`)
    - Database *(support mysql, mssql, sqlite, postgresql)* (eg: `<dialect>+<driver>://<username>:<password>@<host>:<port>/<database>`)
    - HTTP Server (eg: `https://my-server:5000`)
    - Databricks (eg: `databricks://<profileName>`)
- Store
  - `backend store` - store MLflow entities (runs, parameters, metrics, tags, notes, metadata, etc)
    - `Filestore`
    - `SQLAlchemyStore`
    - `RestStore`
  - `artifact store` - persists artifacts (files, models, images, in-memory objects, or model summary, etc)
    - `LocalArtifactRepository`
    - `S3ArtifactRepository`
    - `HttpArtifactRepository`
- `flavors`
- `tag`
## Commands
### Setting Up
- `mlflow.set_tracking_uri()` or set environment variable `MLFLOW_TRACKING_URI `  
- `mlflow.get_tracking_uri()`  
- `mlflow.create_experiment()` - create a new experiment and returns its ID  
- `mlflow.set_experiment()` - set an experiment as active  
- `mlflow.start_run(run_id=...)`  
- `mlflow.end_run()`  
- `mlflow ui`  
- `mlflow.active_run()`  
- `mlflow.last_active_run()`  

### Logging
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
- `mlflow.log_artifacts()`  
- `mlflow.get_artifact_uri()`  
- `mlflow.autolog() `  
  - Scikit-learn - `mlflow.sklearn.autolog()`
  - Keras - `mlflow.tensorflow.autolog() `
  - Gluon - `mlflow.gluon.autolog()`
  - XGBoost - `mlflow.xgboost.autolog()`
  - LightGBM - `mlflow.lightgbm.autolog()`
  - Statsmodels - `mlflow.statsmodels.autolog()`
  - Spark - `mlflow.spark.autolog()`
  - Fastai - ` mlflow.fastai.autolog()`
  - Pytorch - `mlflow.pytorch.autolog()`

### Tracking Service API
``` python
from  mlflow.tracking import MlflowClient
client = MlflowClient()
```

# MLFlow Projects


# MLFlow Models


# MLFlow Registry

