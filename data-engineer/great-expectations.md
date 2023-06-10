# Great Expectations
*(refer to [official documentation](https://docs.greatexpectations.io/docs/))*

Great Expectations is a tool for validating, documenting and profiling data to maintain quality.

# Installation
``` shell
pip install great_expectations
```

# Quick Start
``` python
import great_expectations as gx

# create DataContext object
context = gx.get_context()

# connect to data
validator = context.sources.pandas_default.read_csv(
    "https://raw.githubusercontent.com/great-expectations/gx_tutorials/main/data/yellow_tripdata_sample_2019-01.csv"
)

# create expectations
validator.expect_column_values_to_not_be_null("pickup_datetime")
validator.expect_column_values_to_be_between("passenger_count", auto=True)

# define a checkpoint
checkpoint = gx.checkpoint.SimpleCheckpoint(
    name="my_quickstart_checkpoint",
    data_context=context,
    validator=validator,
)

# return the validation results
checkpoint_result = checkpoint.run()

# view the html representation of the validation resultss
validation_result_identifier = checkpoint_result.list_validation_result_identifiers()[0]
context.open_data_docs(resource_identifier=validation_result_identifier)
```


# Key Features
- **Expectations** - assertions about your data
- **Automated data profiling**
- **Data validation**
- **Data docs**
- **Support for various datasource and store backends**


# Configuration
There are a few components that can be configured.
- Stores - location where Data Context stores information about your Expectations, validation results and metrics
- Data docs - Human readable renderings of your Expectations suites and validation results
- Plugins - Python files to extend functionality of Great Expectations (e.g. Custom Expectations)


# Data Context
Data context contains your Great Expectations project, and it is entry point for configurating and interacting with Great Expectations. A data context contains the configuration for Expectations, Metadata Stores, Data Docs, Checkpoints and all things related to working with Great Expectation

``` python
import great_expectations as gx

context = gx.get_context()
```

Type of data context
- Cloud data context (if GX Cloud was configured)
- Filesystem data context (last accessed Filesystem data context)
- Ephemeral data context

To persist an ephemeral data context after current Python session, you can convert it to Filesystem data context
``` python
context = context.convert_to_file_context()
```
## Filesystem Data Context
``` python
import great_expectations as gx
from great_expectations.data_context import FileDataContext

path_to_empty_folder = "/my_gx_project/"
context = FileDataContext.create(project_root_dir=path_to_empty_folder)
```
It will detect if there are existing filesystem data context and if not, it will initialize a filesystem data context and return it.

One can also use `get_context` method, it will also initialize a filesystem data context if it doesn't exist
``` python
import great_expectations as gx
path_to_context_root_folder = "/my_gx_project/"

context = gx.get_context(context_root_dir=path_to_context_root_folder)
```
## Ephemeral Data Context
``` python
from great_expectations.data_context import EphemeralDataContext
from great_expectations.data_context.types.base import (
    DataContextConfig,
    InMemoryStoreBackendDefaults,
)

project_config = DataContextConfig(
    store_backend_defaults=InMemoryStoreBackendDefaults()
)

context = EphemeralDataContext(project_config=project_config)
```

You can configure credentials in the file `great_expectations/uncommitted/config_variables.yml`. It can work with secret manager from AWS, GCP, Azure.
